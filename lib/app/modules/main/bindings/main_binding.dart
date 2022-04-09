import 'package:get/get.dart';
import 'package:lost_n_found/app/modules/home/controllers/home_controller.dart';
import 'package:lost_n_found/app/modules/news/controllers/news_controller.dart';
import 'package:lost_n_found/app/modules/profile/controllers/profile_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<NewsController>(
      () => NewsController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
