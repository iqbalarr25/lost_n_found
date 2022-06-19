import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';

class AuthController extends GetxController {
  static final box = GetStorage();
  static String url =
      "https://telu-lost-and-found.herokuapp.com/lost-and-found/";

  static void logout() {
    box.erase();
    Get.offAllNamed(Routes.LOGIN);
  }
}
