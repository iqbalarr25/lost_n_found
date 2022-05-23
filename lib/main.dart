import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lost_n_found/app/modules/main/bindings/main_binding.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';
import 'app/modules/main/views/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
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
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.transparent),
        primaryColor: primaryColor,
        colorScheme: ColorScheme.light(primary: primaryColor),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
