import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'dart:convert';

import '../../../themes/theme_app.dart';

class RegisterController extends GetxController {
  final count = 0.obs;
  var passwordVisible = true.obs;
  var confirmPasswordVisible = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var openOtp = false.obs;
  TextEditingController otpControllerOne = TextEditingController();
  TextEditingController otpControllerTwo = TextEditingController();
  TextEditingController otpControllerThree = TextEditingController();
  TextEditingController otpControllerFour = TextEditingController();

  late Timer timer;
  var startTime = 120.obs;

  Future register() async {
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
    Uri uri = Uri.parse(AuthController.url + "auth/register");
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
        },
        body: json.encode({
          "email": emailController.text,
          "name": namaController.text,
          "password": passwordController.text,
          "confirmPassword": confirmPasswordController.text,
        }),
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;
      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 201) {
        print("BERHASIL REGISTER");
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Berhasil menambahkan akun.",
        ).then((value) {
          Get.reloadAll();
          Get.toNamed(Routes.LOGIN);
        });
      } else if (statusCode == 500) {
        defaultDialog = Get.defaultDialog(
          title: "GAGAL",
          middleText: "Email telah dipakai!",
        ).then((value) {
          Get.back();
          Get.back();
        });
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat melakukan register. Hubungi customer service kami.");
    }
  }

  void startTimer() {
    startTime.value = 120;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if (startTime.value <= 0) {
        timer.cancel();
      } else {
        startTime--;
      }
    });
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
    passwordController.dispose();
    timer.cancel();
    super.onClose();
  }

  void increment() => count.value++;
}
