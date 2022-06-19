import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'dart:convert';

import '../../../themes/theme_app.dart';

class RegisterController extends GetxController {
  var passwordVisible = true.obs;
  var confirmPasswordVisible = true.obs;
  TextEditingController emailRegisterController = TextEditingController();
  TextEditingController namaRegisterController = TextEditingController();
  TextEditingController passwordRegisterController = TextEditingController();
  TextEditingController confirmPasswordRegisterController =
      TextEditingController();

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
          "email": emailRegisterController.text,
          "name": namaRegisterController.text,
          "password": passwordRegisterController.text,
          "confirmPassword": confirmPasswordRegisterController.text,
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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (startTime.value <= 0) {
        timer.cancel();
      } else {
        startTime--;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailRegisterController.dispose();
    namaRegisterController.dispose();
    passwordRegisterController.dispose();
    confirmPasswordRegisterController.dispose();
    otpControllerOne.dispose();
    otpControllerTwo.dispose();
    otpControllerThree.dispose();
    otpControllerFour.dispose();
    timer.cancel();
    super.onClose();
  }
}
