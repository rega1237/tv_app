
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart'; // Import para context.watch

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
  Key _playerWidgetKey = UniqueKey();

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
      final activePlaylists = playlists.where((p) => p.schedule != null && now.isAfter(p.schedule!.startDate!) && now.isBefore(p.schedule!.endDate!)).toList();
      
      if (activePlaylists.isEmpty) {
        if (mounted) setState(() => _playbackQueue = []);
        return;
      }

      final dayOfWeek = now.weekday;
      final timeInMinutes = now.hour * 60 + now.minute;
      
      final futureIndividualLists = activePlaylists.map((p) => queryPlaylistIndividualsRecordOnce(parent: p.reference, queryBuilder: (q) => q.where('activeDays', arrayContains: dayOfWeek))).toList();
      final listOfIndividualLists = await Future.wait(futureIndividualLists);
      final allActiveIndividualsNow = listOfIndividualLists.expand((list) => list).where((i) => timeInMinutes >= i.startHour && timeInMinutes <= i.endHour).toList();

      final allFileRefs = allActiveIndividualsNow.expand((i) => i.filesRefs).toList();
      final fileFutures = allFileRefs.map((ref) => FilesRecord.getDocumentOnce(ref));
      final files = (await Future.wait(fileFutures)).where((f) => f != null).cast<FilesRecord>().toList();

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
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }

      if (_currentFileIndex >= _playbackQueue.length) {
        _currentFileIndex = 0;
      }

      final fileToPlay = _playbackQueue[_currentFileIndex];
      print('[PlayerPage] Preparando archivo ${_currentFileIndex + 1}/${_playbackQueue.length}: ${fileToPlay.reference.id}');
      
      await _videoController?.dispose();
      _videoController = null;
      if (mounted) {
        setState(() {
          _playerWidgetKey = UniqueKey();
        });
      }

      Duration duration = const Duration(seconds: 15);

      if (fileToPlay.fileType.startsWith('video/') && fileToPlay.fileUrlVideo.isNotEmpty) {
        _videoController = VideoPlayerController.networkUrl(Uri.parse(fileToPlay.fileUrlVideo));
        try {
          await _videoController!.initialize();
          duration = _videoController!.value.duration;
          
          if (mounted) {
            setState(() {});
          }

          _videoController!.setVolume(0.0);
          _videoController!.play();
          print('[PlayerPage] Video iniciado. Duración: ${duration.inSeconds} segundos.');
        } catch (e) {
          print('[PlayerPage] ERROR al inicializar video: $e. Saltando en 5s.');
          duration = const Duration(seconds: 5);
          _videoController = null;
        }
      } else {
        print('[PlayerPage] Mostrando imagen. Duración: 15 segundos.');
      }

      await Future.delayed(duration);

      _currentFileIndex++;
    }
  }

  Widget _buildPlayer() {
    if (_playbackQueue.isEmpty) {
      return Center(child: Text('No content scheduled.', style: TextStyle(color: Colors.white)));
    }

    if (_currentFileIndex >= _playbackQueue.length) {
      return Center(child: CircularProgressIndicator());
    }

    final fileToPlay = _playbackQueue[_currentFileIndex];
    final fileType = fileToPlay.fileType.toLowerCase();

    if (fileType.startsWith('video/')) {
      if (_videoController != null && _videoController!.value.isInitialized) {
        return Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _videoController!.value.size.width,
              height: _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
            ),
          ),
        );
      }
      return Center(child: CircularProgressIndicator());
    } else if (fileType.startsWith('image/')) {
      return Center(child: Image.network(fileToPlay.fileUrl, fit: BoxFit.contain));
    } else {
      return Center(child: Text('Unsupported format: ${fileToPlay.fileType}', style: TextStyle(color: Colors.white)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Leemos el estado global para la rotación
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
      body: KeyedSubtree(
        key: _playerWidgetKey,
        child: _buildPlayer(),
      ),
    );

    // Aplicamos RotatedBox a todo el Scaffold solo si es necesario
    return quarterTurns != 0
        ? RotatedBox(quarterTurns: quarterTurns, child: playerScaffold)
        : playerScaffold;
  }
}
