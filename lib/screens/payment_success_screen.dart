import 'package:flutter/material.dart';
import 'package:projek_mobile/data/interest_data.dart';
import 'package:projek_mobile/providers/theme_provider.dart';
import 'package:projek_mobile/screens/explore_page.dart';
import 'package:projek_mobile/screens/my_course_page.dart';
import 'package:projek_mobile/firebase/firebase_analytics_service.dart';
import 'package:provider/provider.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';
import 'package:projek_mobile/services/ad_service.dart';
import 'package:projek_mobile/widgets/banner_ad_widget.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Color(0xFF324EAF),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Color(0xFF324EAF),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Tooltip(
          message: 'Back',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/payment_success.png',
                height: isMobile ? 180 : 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              // Banner ad placed above CTAs
              BannerAdWidget(adUnitId: AdService.bannerUnitId),
              const SizedBox(height: 18),
              Text(
                AppLocalizations.of(context).paymentSuccessful,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Thank you for your payment. Your course is now unlocked and ready to access. Happy learning!\n\nGo to My Course page to learn your new course!',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAnalyticsService().trackButtonClick(
                    'continue_shopping',
                    extras: {'screen': 'payment_success'},
                  );
                  await AdService.instance.showInterstitial();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              ExplorePage(selectedCategory: categoryselected),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.black : Colors.white,
                  side: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF324EAF),
                  ),
                  foregroundColor:
                      isDarkMode ? Colors.white : const Color(0xFF324EAF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Continue Shopping'),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAnalyticsService().trackButtonClick(
                    'go_to_my_course',
                    extras: {'screen': 'payment_success'},
                  );
                  await AdService.instance.showInterstitial();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MyCoursePage()),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to My Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
