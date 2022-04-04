import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/modules/main/bindings/main_binding.dart';
import 'package:lost_n_found/app/modules/post/bindings/post_binding.dart';
import 'package:lost_n_found/app/modules/post/views/post_view.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';
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
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      home: MainView(),
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.light(primary: primaryColor),
      ),
    );
  }
}
