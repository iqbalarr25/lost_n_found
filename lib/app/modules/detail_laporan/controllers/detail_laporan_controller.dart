import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

class DetailLaporanController extends GetxController {
  var currentPos = 0.obs;

  List<Widget> listPaths = [
    Container(color: blackColor),
    Container(color: greyColor),
    Container(color: blackColor),
    Container(color: greyColor),
  ];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
