import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_mobile/models/explore_model.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/video_play.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';

class VideoPlayer extends StatelessWidget {
  final Course course;

  const VideoPlayer({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          AppLocalizations.of(context).courseVideosTitle,
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.white : Color(0xFF324EAF),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        foregroundColor: isDarkMode ? Colors.white : Color(0xFF324EAF),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                course.images,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  course.title,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Color(0xFF324EAF),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(9, (index) {
                    final l10n = AppLocalizations.of(context);

                    return ExpansionTile(
                      title: Text(
                        l10n.moduleTitle(index + 1),
                        style: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.white : Color(0xFF324EAF),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: [
                        _buildComingSoonTile(
                          context,
                          l10n.comingSoon,
                          index + 1,
                        ),
                      ],
                    );
                  }),
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
                label: Text(AppLocalizations.of(context).video),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_copy, size: 18),
                label: Text(AppLocalizations.of(context).resource),
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
