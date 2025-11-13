import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:projek_mobile/firebase/firebase_analytics_service.dart';

class SocialButton extends StatelessWidget {
  final String screen;
  const SocialButton({super.key, this.screen = 'auth'});

  // Helper to map asset name to provider
  String _providerFromAsset(String asset) {
    final lower = asset.toLowerCase();
    if (lower.contains('google')) return 'google';
    if (lower.contains('facebook')) return 'facebook';
    if (lower.contains('linkedin')) return 'linkedin';
    return 'social';
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder that immediately resolves with the list of social urls.
    // This does not change behavior but introduces an extra FutureBuilder.
    return FutureBuilder<List<String>>(
      future: Future.value([
        "https://accounts.google.com",
        "https://www.facebook.com/login/",
        "https://www.linkedin.com/authwall",
      ]),
      builder: (context, snap) {
        // Keep the original assets order but prefer URLs coming from the future
        final urls =
            snap.data ??
            [
              "https://accounts.google.com",
              "https://www.facebook.com/login/",
              "https://www.linkedin.com/authwall",
            ];

        return Wrap(
          spacing: 25,
          children: [
            _buildSocialIcon("assets/icons/google.svg", urls[0]),
            _buildSocialIcon("assets/icons/facebook.svg", urls[1]),
            _buildSocialIcon("assets/icons/linkedin.svg", urls[2]),
          ],
        );
      },
    );
  }

  Widget _buildSocialIcon(String asset, String url) {
    final provider = _providerFromAsset(asset);
    return InkWell(
      onTap: () async {
        // Log analytics for social button
        try {
          await FirebaseAnalyticsService().trackButtonClick(
            'social_${provider}_tap',
            extras: {'screen': screen, 'provider': provider},
          );
        } catch (_) {}

        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: SvgPicture.asset(asset, height: 30),
    );
  }
}
