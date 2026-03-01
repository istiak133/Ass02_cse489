import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isPaused = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          _isPaused = state == PlayerState.paused;
        });
      }
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() {
          _duration = d;
        });
      }
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });

    // Listen to completion
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    // Playing the local audio file from assets
    await _audioPlayer.play(AssetSource('sample_audio.mp3'));
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  Future<void> _resume() async {
    await _audioPlayer.resume();
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _position = Duration.zero;
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Music icon
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.music_note : Icons.music_off,
                size: 80,
                color: _isPlaying ? Colors.blue : Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            const Text(
              'Sample Audio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isPlaying
                  ? 'Now Playing...'
                  : _isPaused
                      ? 'Paused'
                      : 'Tap Play to start',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            // Progress bar
            Slider(
              value: _position.inMilliseconds.toDouble(),
              min: 0,
              max: _duration.inMilliseconds > 0
                  ? _duration.inMilliseconds.toDouble()
                  : 1.0,
              onChanged: (val) {
                _audioPlayer.seek(Duration(milliseconds: val.toInt()));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_position)),
                  Text(_formatDuration(_duration)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play button
                ElevatedButton.icon(
                  onPressed: _isPlaying ? null : (_isPaused ? _resume : _play),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Pause button
                ElevatedButton.icon(
                  onPressed: _isPlaying ? _pause : null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Stop button
                ElevatedButton.icon(
                  onPressed:
                      (_isPlaying || _isPaused) ? _stop : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    backgroundColor: Colors.red.shade100,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
