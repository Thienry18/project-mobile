import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key});

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
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: SvgPicture.asset(asset, height: 30),
    );
  }
}
