import 'dart:math';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final String courseTitle;

  const ShareButton({super.key, required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () => _showShareOptions(context),
    );
  }

  void _showShareOptions(BuildContext context) {
    final random = Random();
    final code = String.fromCharCodes(
      List.generate(6, (index) => random.nextInt(26) + 97),
    );
    final fakeUrl = 'https://courses.com/$code';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this course with:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              children: [
                _buildShareIcon(context, icon: Icons.chat, label: 'WhatsApp', onTap: () {
                  Share.share('Check this course: $courseTitle\n$fakeUrl', subject: 'Share via WhatsApp');
                }),
                _buildShareIcon(context, icon: Icons.facebook, label: 'Facebook', onTap: () {
                  Share.share('Check this course: $courseTitle\n$fakeUrl', subject: 'Share via Facebook');
                }),
                _buildShareIcon(context, icon: Icons.camera_alt, label: 'Instagram', onTap: () {
                  Share.share('Check this course: $courseTitle\n$fakeUrl', subject: 'Share via Instagram');
                }),
                _buildShareIcon(context, icon: Icons.music_note, label: 'TikTok', onTap: () {
                  Share.share('Check this course: $courseTitle\n$fakeUrl', subject: 'Share via TikTok');
                }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildShareIcon(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Tutup sheet dulu
        onTap();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
     ),
);}
}