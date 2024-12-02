import 'package:check_admob/widgets/count_down_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../reward_ads_service.dart';
import '../widgets/horizontal_radio.dart';
import 'home_page_controller.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  Color getStatusColor(AdsState status) {
    switch (status) {
      case AdsState.none:
        return Colors.black;
      case AdsState.loading:
        return Colors.orange;
      case AdsState.ready:
        return Colors.green;
      case AdsState.showing:
        return Colors.blue;
      case AdsState.error:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Reward Ads'),
      ),
      body: Obx(
        () => Column(
          children: [
            HorizontalRadio(
              titles: const ['Test Ads', 'Product Ads'],
              values: const [
                HomePageController.test,
                HomePageController.product
              ],
              groupValue: controller.adsMode.value,
              callback: controller.changeAdsMode,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              CountDownButton(
                countDown: controller.loadingCountDown.value,
                text: 'Load ads',
                callback: controller.loadAds,
              ),
              CountDownButton(
                countDown: controller.isAdLoad.value,
                text: 'Show Ads',
                callback: controller.showAds,
              )
            ]),
            const Gap(20),
            Text(
              'Status: ${controller.status.value.name}',
              style: TextStyle(color: getStatusColor(controller.status.value)),
            ),
            const Gap(20),
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.logEntries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.logEntries[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
