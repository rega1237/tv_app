import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'; // Import for Cache Manager

class PlayerPageWidget extends StatefulWidget {
  const PlayerPageWidget({
    super.key,
    required this.channelRef,
  });

  final DocumentReference channelRef;

  @override
  State<PlayerPageWidget> createState() => _PlayerPageWidgetState();
}

class _PlayerPageWidgetState extends State<PlayerPageWidget> {
  List<FilesRecord> _playbackQueue = [];
  int _currentFileIndex = 0;
  Timer? _pollingTimer;

  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    print('[PlayerPage] initState: Iniciando...');
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _buildPlaybackQueue(); // Initial fetch
    _pollingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      print('[PlayerPage] Timer activado: Re-evaluando la cola de reproducción...');
      _buildPlaybackQueue();
    });
    _playbackLoop(); // Start the infinite playback loop
  }

  @override
  void dispose() {
    print('[PlayerPage] dispose: Cancelando timer y liberando controlador de video.');
    _pollingTimer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _buildPlaybackQueue() async {
    print('[PlayerPage] _buildPlaybackQueue: Iniciando búsqueda de contenido...');
    try {
      final channel = await ChannelsRecord.getDocumentOnce(widget.channelRef);
      if (!mounted) return;

      final playlistFutures = channel.playlistRef.map((ref) => PlaylistRecord.getDocumentOnce(ref));
      final playlists = (await Future.wait(playlistFutures)).where((p) => p != null).cast<PlaylistRecord>().toList();

      final now = DateTime.now();
      final activePlaylists = playlists.where((p) {
        if (p.schedule == null || p.schedule!.startDate == null || p.schedule!.endDate == null) {
          return false;
        }
        // La fecha de fin debe ser inclusiva. El playlist es válido DURANTE todo el endDate.
        // Por lo tanto, la fecha de expiración real es al inicio del día SIGUIENTE.
        final endDate = p.schedule!.endDate!;
        final expiryDate = DateTime(endDate.year, endDate.month, endDate.day + 1);
        
        return now.isAfter(p.schedule!.startDate!) && now.isBefore(expiryDate);
      }).toList();
      
      List<FilesRecord> files = [];
      if (activePlaylists.isNotEmpty) {
        final dayOfWeek = now.weekday;
        final timeInMinutes = now.hour * 60 + now.minute;
        
        final futureIndividualLists = activePlaylists.map((p) => queryPlaylistIndividualsRecordOnce(parent: p.reference, queryBuilder: (q) => q.where('activeDays', arrayContains: dayOfWeek))).toList();
        final listOfIndividualLists = await Future.wait(futureIndividualLists);
        final allActiveIndividualsNow = listOfIndividualLists.expand((list) => list).where((i) => timeInMinutes >= i.startHour && timeInMinutes <= i.endHour).toList();

        final allFileRefs = allActiveIndividualsNow.expand((i) => i.filesRefs).toList();
        final fileFutures = allFileRefs.map((ref) => FilesRecord.getDocumentOnce(ref));
        files = (await Future.wait(fileFutures)).where((f) => f != null).cast<FilesRecord>().toList();
      }

      if (mounted) {
        final isNewQueueDifferent = !listEquals(_playbackQueue.map((f) => f.reference).toList(), files.map((f) => f.reference).toList());
        print('[PlayerPage] ¿La nueva cola es diferente a la actual? $isNewQueueDifferent');
        if (isNewQueueDifferent) {
          print('[PlayerPage] Nueva cola detectada. Actualizando lista de ${files.length} archivos.');
          setState(() {
            _playbackQueue = files;
            _currentFileIndex = 0;
          });
        }
      }
    } catch (e, s) {
      print('[PlayerPage] ERROR en _buildPlaybackQueue: $e\n$s');
    }
  }

  Future<void> _playbackLoop() async {
    while (mounted) {
      if (_playbackQueue.isEmpty) {
        if (_videoController != null) {
          await _videoController?.dispose();
          if (mounted) {
            setState(() {
              _videoController = null;
            });
          }
        }
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }

      if (_currentFileIndex >= _playbackQueue.length) {
        _currentFileIndex = 0;
      }

      final fileToPlay = _playbackQueue[_currentFileIndex];
      print('[PlayerPage] Preparando archivo ${_currentFileIndex + 1}/${_playbackQueue.length}: ${fileToPlay.reference.id}');
      
      VideoPlayerController? newController;
      Duration nextDuration = const Duration(seconds: 15);
      bool isSingleVideoLoop = false;

      try {
        if (fileToPlay.fileType.startsWith('video/') && fileToPlay.fileUrlVideo.isNotEmpty) {
          print('[PlayerPage] Obteniendo video desde caché/red...');
          var file = await DefaultCacheManager().getSingleFile(fileToPlay.fileUrlVideo);
          print('[PlayerPage] Video listo desde el archivo local: ${file.path}');
          
          newController = VideoPlayerController.file(file);
          await newController.initialize();
          nextDuration = newController.value.duration;
          
          if (_playbackQueue.length == 1) {
            newController.setLooping(true);
            isSingleVideoLoop = true;
            print('[PlayerPage] Video único detectado. Activando loop nativo.');
          }
        } else if (fileToPlay.fileType.startsWith('image/')) {
          print('[PlayerPage] Mostrando imagen. Duración: 15 segundos.');
        } else {
          print('[PlayerPage] Formato no soportado. Duración: 5 segundos.');
          nextDuration = const Duration(seconds: 5);
        }
      } catch (e) {
        print('[PlayerPage] ERROR al inicializar el nuevo medio: $e. Saltando en 5s.');
        nextDuration = const Duration(seconds: 5);
        _currentFileIndex++;
        await Future.delayed(nextDuration);
        continue;
      }

      if (!mounted) return;

      final oldController = _videoController;
      
      setState(() {
        _videoController = newController;
      });

      if (oldController != null) {
        Future.delayed(const Duration(milliseconds: 50), () => oldController.dispose());
      }
      
      _videoController?.play();
      print('[PlayerPage] Nuevo medio iniciado.');

      if (isSingleVideoLoop) {
        await Completer<void>().future;
      }

      await Future.delayed(nextDuration);
      _currentFileIndex++;
    }
  }

  Widget _buildPlayer() {
    // Comprobación prioritaria: si no hay nada en la cola, mostrar mensaje.
    if (_playbackQueue.isEmpty) {
      return Center(
        child: Text(
          'No content scheduled.',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                fontSize: 24.0,
              ),
        ),
      );
    }

    final currentController = _videoController;

    if (currentController != null && currentController.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: currentController.value.aspectRatio,
          child: VideoPlayer(currentController),
        ),
      );
    }
    
    if (_playbackQueue.isNotEmpty && _currentFileIndex < _playbackQueue.length) {
      final fileToPlay = _playbackQueue[_currentFileIndex];
      if (fileToPlay.fileType.startsWith('image/')) {
        return Center(child: Image.network(fileToPlay.fileUrl, fit: BoxFit.contain));
      }
    }

    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final rotationAngle = FFAppState().rotationAngle;

    int quarterTurns = 0;
    if (rotationAngle == 90.0) {
      quarterTurns = 1;
    } else if (rotationAngle == 270.0) {
      quarterTurns = 3;
    }

    final playerScaffold = Scaffold(
      backgroundColor: Colors.black,
      body: _buildPlayer(),
    );

    return quarterTurns != 0
        ? RotatedBox(quarterTurns: quarterTurns, child: playerScaffold)
        : playerScaffold;
  }
}
