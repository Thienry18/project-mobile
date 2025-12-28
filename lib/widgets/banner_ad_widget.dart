import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  final String adUnitId;
  const BannerAdWidget({super.key, required this.adUnitId});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isFailed = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: widget.adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          setState(() {
            _isFailed = true;
          });
        },
      ),
      request: const AdRequest(),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show a visible placeholder while loading or when failed so the
    // layout indicates where the ad will appear (prevents invisible gap).
    final placeholderHeight = _bannerAd?.size.height.toDouble() ?? 50.0;
    if (!_isLoaded) {
      if (_isFailed) {
        return SizedBox(
          width: double.infinity,
          height: placeholderHeight,
          child: Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: const Text(
              'Ad failed to load',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        );
      }
      return SizedBox(
        width: double.infinity,
        height: placeholderHeight,
        child: Container(
          color: Colors.grey.shade100,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final adHeight = _bannerAd?.size.height.toDouble() ?? 50.0;
    return SizedBox(
      width: double.infinity,
      height: adHeight,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
