import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/screens/video_play.dart'; // sesuaikan path

class VideoPlayer extends StatelessWidget {
  final Course course;

  const VideoPlayer({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar course
              Image.asset(
                course.images,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),

              // Judul
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  course.title,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF324EAF),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ExpansionTile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ExpansionTile(
                  title: Text(
                    'Course Materials',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF324EAF),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [_buildComingSoonTile(context, "Coming Soon", 1)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComingSoonTile(BuildContext context, String title, int number) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with number icon
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: const Color(0xFF324EAF),
                child: Text(
                  number.toString(),
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const AssetVideoScreen(
                            videoPath: 'assets/video/coming_soon.mp4',
                          ),
                    ),
                  );
                },
                icon: const Icon(Icons.ondemand_video, size: 18),
                label: const Text("Video"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_copy, size: 18),
                label: const Text("Resource"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
