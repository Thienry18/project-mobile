import 'package:flutter/material.dart';
import 'package:projek_mobile/screens/certificate.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/widgets/share_button.dart';

class AssetVideoScreen extends StatefulWidget {
  final String videoPath;
  const AssetVideoScreen({super.key, required this.videoPath});

  @override
  State<AssetVideoScreen> createState() => _AssetVideoScreenState();
}

class _AssetVideoScreenState extends State<AssetVideoScreen> {
  late VideoPlayerController _controller;
  bool _showControls = true;
  DateTime? _scheduledDateTime;

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

  Future<void> _pickScheduleDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final scheduled = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _scheduledDateTime = scheduled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Reminder has been set!", style: GoogleFonts.poppins()),
      ),
    );
  }

  void _showMoreOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.workspace_premium, color: Colors.grey),
              title: Text(
                'View Certificate',
                style: GoogleFonts.poppins(color: Color(0xFF324EAF)),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const CertificateImageScreen(
                          imagePath: 'assets/images/certificate.jpg',
                        ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: Colors.grey),
              title: Text(
                'Set Reminder/Schedule',
                style: GoogleFonts.poppins(color: Color(0xFF324EAF)),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickScheduleDateTime();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.grey),
              title: Text(
                'Share Course',
                style: GoogleFonts.poppins(color: Color(0xFF324EAF)),
              ),
              onTap: () {
                Navigator.pop(context);
                showShareOptions(context, 'Certificate of Achievement');
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view, color: Colors.grey),
              title: Text(
                'View Course Details',
                style: GoogleFonts.poppins(color: Color(0xFF324EAF)),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "View Course clicked",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Video Player", style: GoogleFonts.poppins()),
      ),
      body: Column(
        children: [
          if (_scheduledDateTime != null)
            Container(
              width: double.infinity,
              color: Colors.green.shade50,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Reminder set on: ${_scheduledDateTime!.toLocal().toString().substring(0, 16)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.green[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: _toggleControls,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child:
                        _controller.value.isInitialized
                            ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                            : const CircularProgressIndicator(),
                  ),
                  if (_showControls && _controller.value.isInitialized)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.subtitles,
                              color: Colors.white,
                            ),
                            tooltip: 'Subtitles',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Subtitle clicked",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            tooltip: 'More options',
                            onPressed: () => _showMoreOptionsSheet(context),
                          ),
                        ],
                      ),
                    ),
                  if (_showControls && _controller.value.isInitialized)
                    Positioned(
                      bottom: 60,
                      left: 20,
                      right: 20,
                      child: Column(
                        children: [
                          Slider(
                            value: _controller.value.position.inMilliseconds
                                .toDouble()
                                .clamp(
                                  0,
                                  _controller.value.duration.inMilliseconds
                                      .toDouble(),
                                ),
                            min: 0,
                            max:
                                _controller.value.duration.inMilliseconds
                                    .toDouble(),
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                            onChanged: (value) {
                              setState(() {
                                _controller.seekTo(
                                  Duration(milliseconds: value.toInt()),
                                );
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_controller.value.position),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_controller.value.duration),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_showControls && _controller.value.isInitialized)
                    Positioned(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            color: Colors.white,
                            iconSize: 32,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Previous clicked",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.replay_10),
                            color: Colors.white,
                            iconSize: 32,
                            onPressed: _skipBackward,
                          ),
                          const SizedBox(width: 12),
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
                          IconButton(
                            icon: const Icon(Icons.forward_10),
                            color: Colors.white,
                            iconSize: 32,
                            onPressed: _skipForward,
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            color: Colors.white,
                            iconSize: 32,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Next clicked",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
