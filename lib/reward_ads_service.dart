import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdsState {
  none,
  loading,
  ready,
  showing,
  error,
}

class RewardAdsService extends ChangeNotifier {
  final StreamController<AdsState> stateStream = StreamController.broadcast();
  final StreamController<String> eventStream = StreamController.broadcast();
  static final RewardAdsService _instance = RewardAdsService._internal();
  RewardAdsService._internal();

  static get instance => _instance;

  String _adsId = '';
  RewardedAd? _rewardedAd;
  int retryLoad = 2;
  AdsState _adsState = AdsState.none;
  get adsState => _adsState;
  set updateState(AdsState newAdsState) {
    _adsState = newAdsState;
    stateStream.add(_adsState);
  }

  set adsId(String newAds) {
    _adsId = newAds;
  }

  Future<AdsState> loadAds(String place) async {
    if (adsState == AdsState.loading || adsState == AdsState.ready) {
      return adsState;
    }
    updateState = AdsState.loading;
    // trackEvent(AdsEvent.eventNameAdsLoad, place);
    await RewardedAd.load(
      adUnitId: _adsId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          // trackEvent(AdsEvent.eventNameAdsLoadSuccess, place);
          _rewardedAd = ad;
          updateState = AdsState.ready;
          retryLoad = 2;
        },
        onAdFailedToLoad: (err) {
          log('Failed to load a rewarded ad: ${err.message}');
          // trackEvent(AdsEvent.eventNameAdsLoadFail, place);
          updateState = AdsState.error;
        },
      ),
    );
    return adsState;
  }

  void showAds({
    required String place,
    required Function(AdWithoutView adWithoutView, RewardItem reward) onSuccess,
    Function? onShow,
    Function? onClose,
    Function? onError,
  }) {
    if (adsState != AdsState.ready || _rewardedAd == null) {
      log('Ads not ready');
      onError?.call();
      return;
    }
    updateState = AdsState.showing;
    // Call khi user đóng ads
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        onClose?.call();
        loadAds(place);
      },
    );
    // Call ngay khi show ads
    _rewardedAd?.onPaidEvent = (Ad ad, double valueMicros,
        PrecisionType precision, String currencyCode) {
      onShow?.call();
      double value = valueMicros / 1000000;
    };
    _rewardedAd?.show(
      // Call khi user có thể nhận reward (Chưa cần lick tắt quảng cáo)
      onUserEarnedReward: (adWithoutView, reward) {
        onSuccess(adWithoutView, reward);
      },
    );
  }

  void trackEvent(String place, String event,
      {String currency = 'USD', double revenue = 0}) {}
}
