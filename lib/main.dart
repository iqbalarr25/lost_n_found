import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'app/modules/landing/views/landing_view.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingView(),
    );
  }
}
