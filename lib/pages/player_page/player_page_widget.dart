import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

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
  bool _isLoading = true;
  String? _error;
  List<FilesRecord> _playbackQueue = [];
  int _currentFileIndex = 0;
  Timer? _pollingTimer;

  VideoPlayerController? _videoController;
  // This key helps us to change the widget in the tree and force a rebuild
  Key _playerWidgetKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    print('[PlayerPage] initState: Iniciando...');
    _buildPlaybackQueue(); // Initial fetch
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
    // This function now only builds the queue, it doesn't trigger playback.
    // The playback loop will pick up the changes automatically.
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
            _playerWidgetKey = UniqueKey(); // Force recreation of the player widget
          });
        }
      }
    } catch (e, s) {
      print('[PlayerPage] ERROR en _buildPlaybackQueue: $e\n$s');
    }
  }

  Future<void> _playbackLoop() async {
    while (mounted) {
      // If there's nothing to play, wait for a bit and re-check.
      if (_playbackQueue.isEmpty) {
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }

      // Reset index if it's out of bounds
      if (_currentFileIndex >= _playbackQueue.length) {
        _currentFileIndex = 0;
      }

      final fileToPlay = _playbackQueue[_currentFileIndex];
      print('[PlayerPage] Reproduciendo archivo ${_currentFileIndex + 1}/${_playbackQueue.length}: ${fileToPlay.reference.id}');
      
      Duration duration = const Duration(seconds: 15);

      // Set the state to show the current file
      if (mounted) {
        setState(() {
          _playerWidgetKey = UniqueKey(); // Assign a new key to force widget recreation
        });
      }

      if (fileToPlay.fileType.startsWith('video/') && fileToPlay.fileUrlVideo.isNotEmpty) {
        await _videoController?.dispose();
        _videoController = VideoPlayerController.networkUrl(Uri.parse(fileToPlay.fileUrlVideo));
        try {
          await _videoController!.initialize();
          duration = _videoController!.value.duration;
          _videoController!.setVolume(0.0);
          _videoController!.play();
          print('[PlayerPage] Video iniciado. Duración: ${duration.inSeconds} segundos.');
        } catch (e) {
          print('[PlayerPage] ERROR al inicializar video: $e. Saltando en 5s.');
          duration = const Duration(seconds: 5);
        }
      } else {
        print('[PlayerPage] Mostrando imagen. Duración: 15 segundos.');
      }

      // Wait for the duration of the media
      await Future.delayed(duration);

      // Move to the next file for the next iteration of the loop
      _currentFileIndex++;
    }
  }

  Widget _buildPlayer() {
    if (_playbackQueue.isEmpty) {
      return Center(child: Text('No hay contenido programado para este momento.', style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center));
    }

    final fileToPlay = _playbackQueue[_currentFileIndex % _playbackQueue.length];
    final fileType = fileToPlay.fileType.toLowerCase();

    if (fileType.startsWith('video/')) {
      if (_videoController != null && _videoController!.value.isInitialized) {
        return Center(
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        );
      }
      return Center(child: CircularProgressIndicator());
    } else if (fileType.startsWith('image/')) {
      return Image.network(fileToPlay.fileUrl, fit: BoxFit.contain);
    } else {
      return Center(child: Text('Formato no soportado: ${fileToPlay.fileType}', style: TextStyle(color: Colors.white, fontSize: 24)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a KeyedSubtree to ensure the player widget rebuilds when the key changes
    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyedSubtree(
        key: _playerWidgetKey,
        child: _buildPlayer(),
      ),
    );
  }
}
