import 'dart:async';

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
  var confirmPasswordVisible = true.obs;
  var isForgotPassword = false.obs;
  var isOtpSend = false.obs;
  var isAccessResetPasswordConfirmed = false.obs;

  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  TextEditingController confirmPasswordLoginController =
      TextEditingController();

  TextEditingController otpControllerOne = TextEditingController();
  TextEditingController otpControllerTwo = TextEditingController();
  TextEditingController otpControllerThree = TextEditingController();
  TextEditingController otpControllerFour = TextEditingController();

  var userId = "".obs;

  var startTime = 60.obs;
  late Timer timer;

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

  Future sentOtpResetPassword() async {
    timer.cancel();
    startTimer();
    Uri uri = Uri.parse(AuthController.url + "auth/reset-password");
    var response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
      },
      body: json.encode(
        {
          "email": emailLoginController.text,
        },
      ),
    );
    var body = json.decode(response.body) as Map<String, dynamic>;
    var statusCode = response.statusCode;
    print("STATUS CODE : $statusCode");
    print(body);
    if (statusCode == 201) {
      userId.value = body['data']['id'];
      Get.snackbar(
          "OTP Berhasil dikirim", "Cek spam folder jika OTP tidak terkirim",
          backgroundColor: greenDarkColor, colorText: whiteColor);
    } else {
      Get.snackbar("OTP Gagal dikirim", "Email yang dimasukkan tidak valid!",
          backgroundColor: primaryColor, colorText: whiteColor);
    }
  }

  Future confirmOtpResetPassword() async {
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
    try {
      Uri uri =
          Uri.parse(AuthController.url + "user/otp/verify/reset-password");
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
        },
        body: json.encode(
          {
            "userId": userId.value,
            "otp": otpControllerOne.text +
                otpControllerTwo.text +
                otpControllerThree.text +
                otpControllerFour.text,
          },
        ),
      );
      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;
      print("STATUS CODE : $statusCode");
      print(body);
      if (statusCode == 201) {
        isAccessResetPasswordConfirmed.value = body['data'];
        Get.back();
      } else {
        defaultDialog = Get.defaultDialog(
          title: "KESALAHAN",
          content: const Text("OTP salah!"),
        ).then((value) => Get.back());
      }
    } catch (e) {
      print(e);
      errorMsg("Tidak dapat konfirmasi OTP. Hubungi customer service kami.");
    }
  }

  Future resetPassword() async {
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
    try {
      Uri uri = Uri.parse(AuthController.url + "auth/reset-password");
      var response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
        },
        body: json.encode(
          {
            "userId": userId.value,
            "password": passwordLoginController.text,
            "confirmPassword": confirmPasswordLoginController.text,
          },
        ),
      );
      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;
      print("STATUS CODE : $statusCode");
      print(body);
      if (statusCode == 200) {
        Get.back();
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Berhasil mengganti password",
        ).then((value) {
          isForgotPassword.value = false;
          isOtpSend.value = false;
          isAccessResetPasswordConfirmed.value = false;
          otpControllerOne.text = "";
          otpControllerTwo.text = "";
          otpControllerThree.text = "";
          otpControllerFour.text = "";
          confirmPasswordLoginController.text = "";
          timer.cancel();
        });
      } else if (statusCode == 500) {
        defaultDialog = Get.defaultDialog(
          title: "KESALAHAN",
          content: const Text("Password tidak cocok!"),
        ).then((value) => Get.back());
      } else {
        defaultDialog = Get.defaultDialog(
          title: "KESALAHAN",
          content: const Text("Akun tidak valid!"),
        ).then((value) => Get.back());
      }
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat mengganti password. Hubungi customer service kami.");
    }
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
    if (Get.arguments != null && Get.arguments != 0) {
      emailLoginController.text = Get.arguments[0];
      passwordLoginController.text = Get.arguments[1];
    }
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
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
    emailLoginController.dispose();
    passwordLoginController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
