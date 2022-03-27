import 'package:get/get.dart';
import 'package:lost_n_found/controllers/login_page/login_controller.dart';

class ArtikelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
