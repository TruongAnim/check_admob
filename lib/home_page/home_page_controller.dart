import 'dart:async';

import 'package:check_admob/config.dart';
import 'package:check_admob/reward_ads_service.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePageController extends GetxController {
  static const String test = 'test';
  static const String product = 'product';
  final RxInt loadingCountDown = RxInt(AdConfig.loadingInterval);
  final RxInt isAdLoad = RxInt(0);
  final RxString adsMode = RxString(test);
  final Rx<AdsState> status = Rx<AdsState>(AdsState.none);
  RewardAdsService rewardAdsService = RewardAdsService.instance;

  final RxList<String> logEntries = RxList();
  final ScrollController scrollController = ScrollController();
  late StreamSubscription eventSubcription;

  late Timer timer;
  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 1), tick);
    status.bindStream(rewardAdsService.stateStream.stream);
    eventSubcription = rewardAdsService.eventStream.stream.listen((log) {
      _addLogEntry(log);
    });
    changeAdsMode(test);
  }

  @override
  void onClose() {
    scrollController.dispose();
    eventSubcription.cancel();
    super.dispose();
  }

  void tick(Timer t) {
    if (loadingCountDown > 0) {
      loadingCountDown.value -= 1;
    }
  }

  void changeAdsMode(String newMode) {
    adsMode.value = newMode;
    if (newMode == test) {
      rewardAdsService.adsId = AdConfig.testAds;
    } else {
      rewardAdsService.adsId = AdConfig.productAds;
    }
  }

  // Function to add a new log entry
  void _addLogEntry(String newLog) {
    logEntries.add('${DateTime.now()}: $newLog');

    // Scroll to the bottom of the list
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 60,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void loadAds() {
    rewardAdsService.loadAds('');
  }

  void showAds() {
    rewardAdsService.showAds(
        place: '',
        onSuccess: (AdWithoutView adWithoutView, RewardItem reward) {
          _addLogEntry('Add coin');
        },
        onShow: () {
          _addLogEntry('Show Ads');
        },
        onClose: () {
          _addLogEntry('On close');
        },
        onError: () {
          _addLogEntry('On error');
        });
  }
}
