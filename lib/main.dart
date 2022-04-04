import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/modules/main/bindings/main_binding.dart';
import 'app/modules/main/views/main_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MainBinding(),
      debugShowCheckedModeBanner: false,
      home: MainView(),
    );
  }
}
