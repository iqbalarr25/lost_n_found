import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_n_found/app/modules/login/bindings/login_binding.dart';
import 'package:lost_n_found/app/modules/login/views/login_view.dart';
import 'package:lost_n_found/app/modules/main/bindings/main_binding.dart';
import 'package:lost_n_found/app/modules/register/bindings/register_binding.dart';
import 'package:lost_n_found/app/modules/register/views/register_view.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';
import 'app/modules/main/views/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    return GetMaterialApp(
      initialBinding: (box.read('dataUser') == null)
          ? (box.read('userOtp') == null)
              ? LoginBinding()
              : RegisterBinding()
          : MainBinding(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      home: (box.read('dataUser') == null)
          ? (box.read('userOtp') == null)
              ? LoginView()
              : RegisterView()
          : MainView(),
      theme: ThemeData(
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
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
