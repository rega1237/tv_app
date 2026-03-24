import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'; // Import for Cache Manager
import 'package:wakelock_plus/wakelock_plus.dart';

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
  Completer<void>? _loopCompleter;
  bool _navigatedToPdf = false;

  @override
  void initState() {
    super.initState();
    FFAppState().lastChannelRef = widget.channelRef;
    WakelockPlus.enable();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _buildPlaybackQueue();
    if (_navigatedToPdf) return;
    _pollingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _buildPlaybackQueue();
    });
    _playbackLoop();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _videoController?.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _buildPlaybackQueue() async {
    try {
      final channel = await ChannelsRecord.getDocumentOnce(widget.channelRef);
      if (!mounted) return;

      final playlistFutures =
          channel.playlistRef.map((ref) => PlaylistRecord.getDocumentOnce(ref));
      final playlists = (await Future.wait(playlistFutures)).toList();

      // Usamos la hora local para las comparaciones de hora del día (startHour/endHour)
      final localNow = DateTime.now();
      final timeInMinutes = localNow.hour * 60 + localNow.minute;
      final dayOfWeek = localNow.weekday;

      // Usamos la hora UTC para las comparaciones de fecha (startDate/endDate) para evitar problemas de zona horaria
      final utcNow = localNow.toUtc();
      final activePlaylists = playlists.where((p) {
        if (p.schedule.startDate == null || p.schedule.endDate == null) {
          return false;
        }

        final startDate = p.schedule.startDate!.toUtc();
        final endDate = p.schedule.endDate!.toUtc();
        final expiryDate =
            DateTime.utc(endDate.year, endDate.month, endDate.day + 1);

        return utcNow.isAfter(startDate) && utcNow.isBefore(expiryDate);
      }).toList();

      PlaylistRecord? menuPlaylist;
      for (final p in activePlaylists) {
        if (p.isMenu) {
          menuPlaylist = p;
          break;
        }
      }

      if (menuPlaylist != null) {
        final individuals = await queryPlaylistIndividualsRecordOnce(
            parent: menuPlaylist.reference,
            queryBuilder: (q) =>
                q.where('activeDays', arrayContains: dayOfWeek));
        final allRefs = individuals.expand((i) => i.filesRefs).toList();
        final fileFutures =
            allRefs.map((ref) => FilesRecord.getDocumentOnce(ref));
        final menuFiles = (await Future.wait(fileFutures)).toList();
        final pdfFiles = menuFiles.where((f) {
          final t = f.fileType.toLowerCase();
          final u = f.fileUrl.toLowerCase();
          final g = f.fileUrlGeneric.toLowerCase();
          return t.contains('pdf') || u.endsWith('.pdf') || g.endsWith('.pdf');
        }).toList();
        _pollingTimer?.cancel();
        _loopCompleter?.complete();
        await _videoController?.dispose();
        _navigatedToPdf = true;
        if (!mounted) return;
        context.goNamedAuth(
          'PdfMenuPage',
          mounted,
          extra: {'pdfFiles': pdfFiles},
        );
        return;
      }

      List<FilesRecord> files = [];
      if (activePlaylists.isNotEmpty) {
        final futureIndividualLists = activePlaylists
            .map((p) => queryPlaylistIndividualsRecordOnce(
                parent: p.reference,
                queryBuilder: (q) =>
                    q.where('activeDays', arrayContains: dayOfWeek)))
            .toList();
        final listOfIndividualLists = await Future.wait(futureIndividualLists);
        final allActiveIndividualsNow = listOfIndividualLists
            .expand((list) => list)
            .where((i) =>
                timeInMinutes >= i.startHour && timeInMinutes <= i.endHour)
            .toList();

        final allFileRefs =
            allActiveIndividualsNow.expand((i) => i.filesRefs).toList();
        final fileFutures =
            allFileRefs.map((ref) => FilesRecord.getDocumentOnce(ref));
        files = (await Future.wait(fileFutures)).toList();
      }

      if (mounted) {
        final isNewQueueDifferent = !listEquals(
            _playbackQueue.map((f) => f.reference).toList(),
            files.map((f) => f.reference).toList());
        if (isNewQueueDifferent) {
          // 1. Cancelamos los procesos antiguos.
          _pollingTimer?.cancel();
          _loopCompleter?.complete();
          await _videoController?.dispose();

          // 2. Actualizamos el estado con la nueva lista de archivos.
          if (mounted) {
            setState(() {
              _videoController = null;
              _playbackQueue = files; // Usamos la nueva lista, no una vacía.
              _currentFileIndex = 0;
            });
          }

          // Esperamos un instante para que el setState se procese.
          await Future.delayed(const Duration(milliseconds: 50));

          // 3. Reiniciamos los procesos directamente, sin recursión.
          if (mounted) {
            _pollingTimer =
                Timer.periodic(const Duration(seconds: 60), (timer) {
              _buildPlaybackQueue();
            });
            _playbackLoop();
          }
          // Salimos de la función para no continuar con el flujo antiguo.
          return;
        }
      }
    } catch (e) {
      // Ignore error
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

      VideoPlayerController? newController;
      Duration nextDuration = const Duration(seconds: 15);

      try {
        if (fileToPlay.fileType.startsWith('video/') &&
            fileToPlay.fileUrlVideo.isNotEmpty) {
          var file = await DefaultCacheManager()
              .getSingleFile(fileToPlay.fileUrlVideo);

          newController = VideoPlayerController.file(file);
          // --- SOLUCIÓN: Añadimos un Timeout de 30 segundos ---
          await newController.initialize().timeout(const Duration(seconds: 30));

          nextDuration = newController.value.duration;

          if (_playbackQueue.length == 1) {
            newController.setLooping(true);
          }
        } else if (fileToPlay.fileType.startsWith('image/')) {
        } else {
          nextDuration = const Duration(seconds: 5);
        }
      } catch (e) {
        // --- SOLUCIÓN: Manejo de error mejorado ---
        _currentFileIndex++;
        await Future.delayed(const Duration(seconds: 1));
        continue;
      }

      if (!mounted) return;

      final oldController = _videoController;

      setState(() {
        _videoController = newController;
      });

      if (oldController != null) {
        Future.delayed(
            const Duration(milliseconds: 50), () => oldController.dispose());
      }

      _videoController?.play();

      // --- LÓGICA DE ESPERA INTELIGENTE Y UNIFICADA ---
      if (_videoController != null && _videoController!.value.isInitialized) {
        // Caso 1: Es un video que NO está en loop.
        if (!_videoController!.value.isLooping) {
          final completer = Completer<void>();
          late final VoidCallback listener;
          listener = () {
            if (!mounted ||
                _videoController == null ||
                !_videoController!.value.isInitialized) {
              if (!completer.isCompleted) completer.complete();
              return;
            }
            // Comprobamos si la posición ha alcanzado o superado la duración.
            if (_videoController!.value.position >=
                _videoController!.value.duration) {
              if (!completer.isCompleted) {
                completer.complete();
                _videoController!.removeListener(listener);
              }
            }
          };
          _videoController!.addListener(listener);
          await completer.future;
        } else {
          // Caso 2: Es un video único en loop. Esperamos hasta que nos interrumpan.
          _loopCompleter = Completer<void>();
          await _loopCompleter!.future;
        }
      } else {
        // Caso 3: Es una imagen. Usamos el temporizador simple.
        await Future.delayed(nextDuration);
      }

      // Si el loop fue interrumpido por un cambio de playlist, no incrementamos el índice.
      if (_loopCompleter?.isCompleted ?? false) {
        _loopCompleter = null; // Reseteamos para la próxima vez.
      } else {
        _currentFileIndex++;
      }
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

    if (_playbackQueue.isNotEmpty &&
        _currentFileIndex < _playbackQueue.length) {
      final fileToPlay = _playbackQueue[_currentFileIndex];
      if (fileToPlay.fileType.startsWith('image/')) {
        return Center(
            child: Image.network(fileToPlay.fileUrl, fit: BoxFit.contain));
      }
    }

    return const Center(child: CircularProgressIndicator());
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
