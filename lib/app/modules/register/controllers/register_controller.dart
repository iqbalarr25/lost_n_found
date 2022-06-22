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
  var startTime = 60.obs;

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
        Get.back();
        startTimer();
        recieveOtp(userId: body['data']['id'], email: body['data']['email']);
        openOtp.value = true;
      } else if (statusCode == 401) {
        print(body['user']['activeStatus']);
        if (body['user']['activeStatus'] == false) {
          Get.back();
          startTimer();
          recieveOtp(userId: body['user']['id'], email: body['user']['email']);
          openOtp.value = true;
        } else {
          defaultDialog = Get.defaultDialog(
            title: "GAGAL",
            middleText: "Email telah dipakai!",
          ).then((value) {
            Get.back();
            Get.back();
          });
        }
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat melakukan register. Hubungi customer service kami.");
    }
  }

  Future recieveOtp({String? userId, String? email}) async {
    if (AuthController.box.read('userOtp') == null) {
      AuthController.box.write(
        'userOtp',
        {
          'userId': userId,
          'email': email,
        },
      );
    }

    var uri = Uri.parse(AuthController.url + "user/otp");
    var response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
      },
      body: json.encode({
        "userId": AuthController.box.read('userOtp')['userId'],
        "email": AuthController.box.read('userOtp')['email'],
      }),
    );
    print("otp: ${response.statusCode}");
    print(response.body);
  }

  void startTimer() {
    startTime.value = 60;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if (startTime.value <= 0) {
        timer.cancel();
      } else {
        startTime--;
      }
    });
  }

  Future verifyOtp({String? userId, String? email}) async {
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
    var uri = Uri.parse(AuthController.url + "user/otp/verify");
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
        },
        body: json.encode({
          "userId": AuthController.box.read('userOtp')['userId'],
          "otp": otpControllerOne.text +
              otpControllerTwo.text +
              otpControllerThree.text +
              otpControllerFour.text,
        }),
      );
      var statusCode = response.statusCode;
      var body = json.decode(response.body) as Map<String, dynamic>;
      print("otp: ${response.statusCode}");
      print(body);

      if (statusCode == 201) {
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Berhasil melakukan verifikasi OTP",
        ).then((value) {
          AuthController.box.remove('userOtp');
          Get.offNamed(Routes.LOGIN);
        });
      } else {
        defaultDialog = Get.defaultDialog(
          title: "GAGAL",
          middleText: "OTP yang dimasukkan salah!",
        ).then((value) {
          Get.back();
          Get.back();
        });
      }
    } catch (e) {
      print(e);
      errorMsg("Tidak dapat konfirmasi OTP. Hubungi customer service kami.");
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
    print(AuthController.box.read('userOtp'));
    if (AuthController.box.read('userOtp') != null) {
      openOtp.value = true;
    }
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
