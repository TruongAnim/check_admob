import 'package:check_admob/home_page/home_page.dart';
import 'package:check_admob/home_page/home_page_binding.dart';
import 'package:get/get.dart';

mixin BaseRouters {
  static const String home = '/home';

  static List<GetPage> listPage = [
    GetPage(
      name: home,
      page: () => const HomePage(),
      binding: HomePageBinding(),
    ),
  ];
}
