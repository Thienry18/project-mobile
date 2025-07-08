import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AssetVideoScreen extends StatefulWidget {
  final String videoPath;
  const AssetVideoScreen({super.key, required this.videoPath});

  @override
  State<AssetVideoScreen> createState() => _AssetVideoScreenState();
}

class _AssetVideoScreenState extends State<AssetVideoScreen> {
  late VideoPlayerController _controller;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _skipForward() {
    final newPosition =
        _controller.value.position + const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void _skipBackward() {
    final newPosition =
        _controller.value.position - const Duration(seconds: 10);
    _controller.seekTo(
      newPosition >= Duration.zero ? newPosition : Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Video Player"),
      ),
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video player
            Center(
              child:
                  _controller.value.isInitialized
                      ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                      : const CircularProgressIndicator(),
            ),

            // Progress bar (bottom)
            if (_showControls && _controller.value.isInitialized)
              Positioned(
                bottom: 60,
                left: 20,
                right: 20,
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Colors.white,
                    bufferedColor: Colors.grey,
                    backgroundColor: Colors.grey[700]!,
                  ),
                ),
              ),

            // Kontrol utama di tengah
            if (_showControls && _controller.value.isInitialized)
              Positioned(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Previous
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      color: Colors.white,
                      iconSize: 32,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Previous clicked")),
                        );
                      },
                    ),
                    const SizedBox(width: 12),

                    // Rewind 10s
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      color: Colors.white,
                      iconSize: 32,
                      onPressed: _skipBackward,
                    ),
                    const SizedBox(width: 12),

                    // Play/Pause
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                      ),
                      color: Colors.white,
                      iconSize: 48,
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                    const SizedBox(width: 12),

                    // Forward 10s
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      color: Colors.white,
                      iconSize: 32,
                      onPressed: _skipForward,
                    ),
                    const SizedBox(width: 12),

                    // Next
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      color: Colors.white,
                      iconSize: 32,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Next clicked")),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
