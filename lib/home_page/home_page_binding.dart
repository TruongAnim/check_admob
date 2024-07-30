import 'package:get/instance_manager.dart';

import 'home_page_controller.dart';

class HomePageBinding extends Bindings{
  
  @override
  void dependencies() {
    Get.put<HomePageController>(HomePageController());
  }
}