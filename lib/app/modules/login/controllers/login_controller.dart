import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'dart:convert';

import '../../../themes/theme_app.dart';

class LoginController extends GetxController {
  late Future autoLoginFuture;
  final count = 0.obs;

  var passwordVisible = true.obs;

  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();

  Future login() async {
    var defaultDialog = Get.dialog(
      Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: whiteColor,
          ),
          padding: const EdgeInsets.all(15),
          child: const CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false,
    );
    Uri uri = Uri.parse(AuthController.url + "auth/login");
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
        },
        body: json.encode({
          "email": emailLoginController.text,
          "password": passwordLoginController.text,
        }),
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;
      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 201) {
        print("BERHASIL LOGIN");
        AuthController.box.write(
          "dataUser",
          {
            "userId": body['data']['userId'],
            "userRole": body['data']['userRole'],
            "token": body['data']['access_token']
          },
        );
        AuthController.box.remove("userOtp");
        Get.offAllNamed(Routes.MAIN);
      } else if (statusCode == 400) {
        defaultDialog = Get.defaultDialog(
          title: "KESALAHAN",
          content: const Text("Email atau password salah!"),
        ).then((value) => Get.back());
      } else if (statusCode == 401) {
        Get.offNamed(Routes.REGISTER);
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg("Tidak dapat melakukan login. Hubungi customer service kami.");
    }
  }

  void errorMsg(String msg) {
    Get.defaultDialog(
      title: "TERJADI KESALAHAN",
      middleText: msg,
    ).then((value) {
      Get.back();
      Get.back();
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailLoginController.dispose();
    passwordLoginController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
