import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_n_found/app/controllers/auth_controller.dart';

class PostController extends GetxController {
  final List<String> mediaSosials = ["WhatsApp", "Instagram", "Line"];
  final List<String> categorys = ["Lost", "Found"];

  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController kronologiController = TextEditingController();
  TextEditingController mediaSosialController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController pertanyaanController = TextEditingController();

  var mediaSosial = "".obs;
  var category = "".obs;
  var selectedImages = <File>[].obs;
  var selectedImagesPath = <String>[].obs;
  var date = DateTime.now().obs;

  Future tambahPost() async {
    print("PROSES POSTING");
    Uri uri = Uri.parse(AuthController.url + "post");
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "userId": AuthController.userId,
          "typePost": category.value,
          "title": judulController.text,
          "description": deskripsiController.text,
          "chronology": kronologiController.text,
          "socialMediaType": mediaSosial.value,
          "socialMedia": mediaSosialController.text,
          "imgUrl": selectedImagesPath,
          "date": dateController.text,
          "activeStatus": true
        }),
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 201) {
        print("BERHASIL MENAMBAHKAN LAPORAN");
        Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Telah berhasil menambahkan laporan.",
        ).then((value) {
          Get.back();
          Get.back();
        });
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      errorMsg(
          "Tidak dapat menambahkan laporan. Hubungi customer service kami.");
    }
  }

  void encodeImage() {
    for (var selectedImage in selectedImages) {
      selectedImagesPath.value
          .add(base64Encode(selectedImage.readAsBytesSync()));
      print(selectedImagesPath[0]);
    }
  }

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      selectedImages.value.add(File(image.path));
      this.selectedImages.refresh();
      selectedImagesPath.value
          .add(base64Encode(File(image.path).readAsBytesSync()));
      this.selectedImagesPath.refresh();
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: date.value,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (newDate == null) return;
    date.value = newDate;
    dateController.text = "${newDate.month}/${newDate.day}/${newDate.year}";
  }

  void radioButtonMediaSosialOnChanged(String value) {
    mediaSosial.value = value;
  }

  void radioButtonCategoryOnChanged(String value) {
    category.value = value;
  }

  void errorMsg(String msg) {
    Get.defaultDialog(
      title: "TERJADI KESALAHAN",
      middleText: msg,
    );
  }

  @override
  void onClose() {}
}
