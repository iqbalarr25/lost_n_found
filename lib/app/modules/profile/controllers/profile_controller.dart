import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

class ProfileController extends GetxController {
  var dataUser = User().obs;
  var onEditProfile = false.obs;
  var isLoading = false.obs;

  TextEditingController namaController = TextEditingController();
  TextEditingController nimController = TextEditingController();
  TextEditingController nomorController = TextEditingController();

  late Future<Rx<User>>? tampilDataUserFuture;

  Future<Rx<User>>? tampilDataUser() async {
    isLoading.value = true;
    Uri uri = Uri.parse(AuthController.url + "users/my-profile");
    print("PROSES TAMPIL POSTING");
    try {
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization':
              'Bearer ' + AuthController.box.read("dataUser")["token"],
        },
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 200) {
        print("BERHASIL MENAMPILKAN DATA USER");

        if (body['data'] != null) {
          dataUser.value = User.fromJson(body['data'] as Map<String, dynamic>);
        }
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg("Tidak dapat membuka profil. Hubungi customer service kami.");
    }
    isLoading.value = false;
    return dataUser;
  }

  Future editProfil() async {
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
    Uri uri = Uri.parse(AuthController.url +
        "users/" +
        AuthController.box.read("dataUser")["userId"]);
    try {
      var response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization':
              'Bearer ' + AuthController.box.read("dataUser")["token"],
        },
        body: json.encode({
          "name": namaController.text,
          "nim": nimController.text,
          "phone": nomorController.text,
        }),
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 200) {
        print("BERHASIL MENGEDIT PROFILE");
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Berhasil mengedit profile.",
        ).then((value) {
          Get.back();
          Get.back();
          tampilDataUserFuture = tampilDataUser();
        });
      } else if (statusCode == 401) {
        Get.defaultDialog(
          title: "TERJADI KESALAHAN",
          middleText: "Silahkan login ulang",
        ).then((value) => AuthController.logout());
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg("Tidak dapat mengedit profil. Hubungi customer service kami.");
    }
  }

  Future pickImageNormal(ImageSource imageSource) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: imageSource, maxWidth: 1000, maxHeight: 1000);
      if (image == null) return;
      Get.back();
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
      Uri uri = Uri.parse(AuthController.url +
          "users/" +
          AuthController.box.read("dataUser")["userId"]);

      Reference ref = FirebaseStorage.instance.ref().child(image.path);
      UploadTask task = ref.putFile(
        File(image.path),
      );
      final imageUrl = await (await task).ref.getDownloadURL();

      try {
        var response = await http.patch(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Accept": "application/json",
            'Authorization':
                'Bearer ' + AuthController.box.read("dataUser")["token"],
          },
          body: json.encode({"imgUrl": imageUrl}),
        );

        var body = json.decode(response.body) as Map<String, dynamic>;
        var statusCode = response.statusCode;

        print("STATUS CODE : $statusCode");
        print(body);

        if (statusCode == 200) {
          if (dataUser.value.imgUrl != null) {
            FirebaseStorage.instance
                .refFromURL(dataUser.value.imgUrl!)
                .delete();
          }
          print("BERHASIL MENGGANTI PROFILE PICTURE");
          tampilDataUserFuture = tampilDataUser();
          Get.back();
        } else if (statusCode == 401) {
          Get.defaultDialog(
            title: "TERJADI KESALAHAN",
            middleText: "Silahkan login ulang",
          ).then((value) => AuthController.logout());
        } else {
          throw "Error : $statusCode";
        }
      } catch (e) {
        print(e);
        errorMsg(
            "Tidak dapat mengganti profil picture. Hubungi customer service kami.");
      }
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  void errorMsg(String msg) {
    Get.defaultDialog(
      title: "TERJADI KESALAHAN",
      middleText: msg,
    ).then((value) {
      Get.offAllNamed(Routes.MAIN);
    });
  }

  @override
  void onInit() {
    super.onInit();
    tampilDataUserFuture = tampilDataUser();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    namaController.dispose();
    nimController.dispose();
    nomorController.dispose();
    super.onClose();
  }
}
