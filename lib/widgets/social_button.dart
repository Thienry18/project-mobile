import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 25,
      children: [
        _buildSocialIcon(
          "assets/icons/google.svg",
          "https://accounts.google.com",
        ),
        _buildSocialIcon(
          "assets/icons/facebook.svg",
          "https://www.facebook.com/login/",
        ),
        _buildSocialIcon(
          "assets/icons/linkedin.svg",
          "https://www.linkedin.com/authwall",
        ),
      ],
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
