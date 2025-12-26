import 'package:google_mobile_ads/google_mobile_ads.dart';
// no direct Flutter widget imports required here

class AdService {
  AdService._private();
  static final AdService instance = AdService._private();

  // Test ad unit IDs from Google
  // Updated banner test unit id (provided)
  static const String bannerUnitId = 'ca-app-pub-3940256099942544/9214589741';
  static const String interstitialUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedUnitId = 'ca-app-pub-3940256099942544/5224354917';

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  Future<InitializationStatus> init() async {
    return MobileAds.instance.initialize();
  }

  // Interstitial
  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd?.setImmersiveMode(true);
          _interstitialAd
              ?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (err) {
          _interstitialAd = null;
        },
      ),
    );
  }

  Future<void> showInterstitial() async {
    if (_interstitialAd == null) {
      loadInterstitial();
      return;
    }
    try {
      _interstitialAd?.show();
      _interstitialAd = null;
    } catch (_) {}
  }

  // Rewarded
  void loadRewarded() {
    RewardedAd.load(
      adUnitId: rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewarded();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _rewardedAd = null;
              loadRewarded();
            },
          );
        },
        onAdFailedToLoad: (err) {
          _rewardedAd = null;
        },
      ),
    );
  }

  Future<bool> showRewarded({
    required void Function(RewardItem) onEarned,
  }) async {
    if (_rewardedAd == null) {
      loadRewarded();
      return false;
    }
    try {
      _rewardedAd?.show(
        onUserEarnedReward: (ad, reward) {
          onEarned(reward);
        },
      );
      _rewardedAd = null;
      return true;
    } catch (_) {
      return false;
    }
  }
}
