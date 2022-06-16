import 'package:get/get.dart';

class MainController extends GetxController {
  var args = Get.arguments;

  var selectedIndex = 0.obs;
  final count = 0.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      selectedIndex.value = args;
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
