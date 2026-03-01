import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // Using a sample video from the internet
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    try {
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 12),
            Text(
              'Failed to load video.\nCheck internet connection.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading video...', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        // Video Player
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        // Progress bar
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, VideoPlayerValue value, child) {
            return Column(
              children: [
                Slider(
                  value: value.position.inMilliseconds.toDouble(),
                  min: 0,
                  max: value.duration.inMilliseconds.toDouble(),
                  onChanged: (val) {
                    _controller.seekTo(Duration(milliseconds: val.toInt()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(value.position)),
                      Text(_formatDuration(value.duration)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        // Controls
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rewind 10s
              IconButton(
                onPressed: () {
                  final newPosition =
                      _controller.value.position - const Duration(seconds: 10);
                  _controller.seekTo(newPosition);
                },
                icon: const Icon(Icons.replay_10),
                iconSize: 36,
              ),
              const SizedBox(width: 16),
              // Play / Pause
              ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, VideoPlayerValue value, child) {
                  return FloatingActionButton(
                    onPressed: () {
                      if (value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    },
                    child: Icon(
                      value.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 36,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              // Forward 10s
              IconButton(
                onPressed: () {
                  final newPosition =
                      _controller.value.position + const Duration(seconds: 10);
                  _controller.seekTo(newPosition);
                },
                icon: const Icon(Icons.forward_10),
                iconSize: 36,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
