import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';

class PostController extends GetxController {
  final List<String> mediaSosials = ["WhatsApp", "Instagram", "Line"];
  final List<String> categorys = ["Lost", "Found"];

  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController kronologiController = TextEditingController();
  TextEditingController mediaSosialController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController pertanyaanController = TextEditingController();

  var post = MyPost().obs;

  var postId = "".obs;
  var isLoading = false.obs;
  var mediaSosial = "".obs;
  var category = "".obs;

  var selectedImages = <File>[].obs;
  var selectedImagesPath = <String>[].obs;
  var selectedImagesPathPost = <String>[].obs;

  var selectedImagesEdit = <Widget>[].obs;
  var selectedImagesPathEdit = <String>[].obs;
  var selectedImagesPathEditPost = <String>[].obs;

  var selectedImagesOnDeletePath = <String>[].obs;

  var date = DateTime.now().obs;
  var isImageEmpty = false.obs;

  Future tambahPost() async {
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
    print("PROSES POSTING");
    Uri uri = Uri.parse(AuthController.url + "posts");
    try {
      await Future.forEach(selectedImagesPath, (element) async {
        Reference ref = FirebaseStorage.instance.ref().child(element as String);
        UploadTask task =
            ref.putFile(selectedImages[selectedImagesPath.indexOf(element)]);
        final imageUrl = await (await task).ref.getDownloadURL();
        selectedImagesPathPost.add(imageUrl);
      });

      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization':
              'Bearer ' + AuthController.box.read("dataUser")["token"],
        },
        body: json.encode({
          "userId": AuthController.box.read("dataUser")["userId"],
          "typePost": category.value,
          "title": judulController.text,
          "description": deskripsiController.text,
          "chronology": kronologiController.text,
          "socialMediaType": mediaSosial.value,
          "socialMedia": mediaSosialController.text,
          "imgUrl": selectedImagesPathPost,
          "date": dateController.text,
          "activeStatus": true,
          "deleteStatus": false
        }),
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      if (category.value == "Found") {
        postId.value = body['data']['id'];
        tambahQuestion();
      }

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 201) {
        print("BERHASIL MENAMBAHKAN LAPORAN");
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Berhasil menambahkan laporan.",
        ).then((value) {
          Get.offAllNamed(Routes.MAIN, arguments: 0);
          Get.reloadAll();
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
      errorMsg(
          "Tidak dapat menambahkan laporan. Hubungi customer service kami.");
    }
  }

  Future editPost() async {
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

    Uri uri = Uri.parse(AuthController.url + "posts/" + post.value.id!);
    try {
      if (selectedImagesPathEdit.isNotEmpty) {
        await Future.forEach(selectedImagesPathEdit, (element) async {
          Reference ref =
              FirebaseStorage.instance.ref().child(element as String);
          UploadTask task = ref
              .putFile(selectedImages[selectedImagesPathEdit.indexOf(element)]);
          final imageUrl = await (await task).ref.getDownloadURL();
          selectedImagesPathPost.add(imageUrl);
        });

        selectedImagesPathPost.value = [
          ...selectedImagesPath,
          ...selectedImagesPathPost
        ];
        print("INI WOY" + selectedImagesPathPost.toString());

        var response = await http.patch(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Accept": "application/json",
            'Authorization':
                'Bearer ' + AuthController.box.read("dataUser")["token"],
          },
          body: json.encode({
            "typePost": category.value,
            "title": judulController.text,
            "description": deskripsiController.text,
            "chronology": kronologiController.text,
            "socialMediaType": mediaSosial.value,
            "socialMedia": mediaSosialController.text,
            "imgUrl": selectedImagesPathPost,
            "date": dateController.text,
          }),
        );

        var body = json.decode(response.body) as Map<String, dynamic>;
        var statusCode = response.statusCode;

        if (category.value == "Found") {
          editQuestion();
        }

        print("STATUS CODE : $statusCode");
        print(body);

        if (statusCode == 200) {
          selectedImagesOnDeletePath.forEach((element) {
            FirebaseStorage.instance.refFromURL(element).delete();
            print("ini yang di delete " + element);
          });
          print("BERHASIL Edit Laporan yang ber-ID : $post.value.id");
          defaultDialog = Get.defaultDialog(
            title: "BERHASIL",
            middleText: "Berhasil mengedit laporan.",
          ).then((value) {
            Get.offAllNamed(Routes.MAIN, arguments: 0);
            Get.reloadAll();
          });
        } else if (statusCode == 401) {
          Get.defaultDialog(
            title: "TERJADI KESALAHAN",
            middleText: "Silahkan login ulang",
          ).then((value) => AuthController.logout());
        } else {
          throw "Error : $statusCode";
        }
      } else {
        var response = await http.patch(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Accept": "application/json",
            'Authorization':
                'Bearer ' + AuthController.box.read("dataUser")["token"],
          },
          body: json.encode({
            "typePost": category.value,
            "title": judulController.text,
            "description": deskripsiController.text,
            "chronology": kronologiController.text,
            "socialMediaType": mediaSosial.value,
            "socialMedia": mediaSosialController.text,
            "imgUrl": selectedImagesPath,
            "date": dateController.text,
          }),
        );

        var body = json.decode(response.body) as Map<String, dynamic>;
        var statusCode = response.statusCode;

        if (category.value == "Found") {
          editQuestion();
        }

        print("STATUS CODE : $statusCode");
        print(body);

        if (statusCode == 200) {
          print("BERHASIL Edit Laporan yang ber-ID : $post.value.id");
          defaultDialog = Get.defaultDialog(
            title: "BERHASIL",
            middleText: "Berhasil mengedit laporan.",
          ).then((value) {
            Get.toNamed(Routes.MAIN, arguments: 0);
          });
        } else if (statusCode == 401) {
          Get.defaultDialog(
            title: "TERJADI KESALAHAN",
            middleText: "Silahkan login ulang",
          ).then((value) => AuthController.logout());
        } else {
          throw "Error : $statusCode";
        }
      }
    } catch (e) {
      print(e);
      errorMsg("Tidak dapat mengedit laporan. Hubungi customer service kami.");
    }
  }

  Future tambahQuestion() async {
    try {
      Uri uri = Uri.parse(AuthController.url + "questions");
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization':
              'Bearer ' + AuthController.box.read("dataUser")["token"],
        },
        body: json.encode({
          "userId": AuthController.box.read("dataUser")["userId"],
          "postId": postId.value,
          "typeQuestion": "PostQuestion",
          "question": pertanyaanController.text,
          "statusQuestion": "Waiting",
        }),
      );

      var bodyQuestion = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(bodyQuestion);

      if (statusCode == 201) {
        print("BERHASIL MENAMBAHKAN QUESTION");
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
          "Tidak dapat menambahkan pertanyaan. Hubungi customer service kami.");
    }
  }

  Future editQuestion() async {
    try {
      Uri uri = Uri.parse(
          AuthController.url + "questions/" + post.value.questions![0].id!);
      var response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization':
              'Bearer ' + AuthController.box.read("dataUser")["token"],
        },
        body: json.encode({
          "question": pertanyaanController.text,
        }),
      );
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat mengedit pertanyaan. Hubungi customer service kami.");
    }
  }

  Future pickImageNormal(ImageSource imageSource) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: imageSource, maxWidth: 1000, maxHeight: 1000);
      if (image == null) return;

      selectedImages.add(File(image.path));
      selectedImages.refresh();
      selectedImagesPath.add(basename(image.path));
      selectedImagesPath.refresh();
      print(selectedImages);
      print(selectedImagesPath.toString() + "post normal");
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future pickImageEdit(ImageSource imageSource) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: imageSource, maxWidth: 1000, maxHeight: 1000);
      if (image == null) return;

      selectedImagesEdit.add(Image.file(File(image.path)));
      selectedImagesEdit.refresh();
      selectedImages.add(File(image.path));
      selectedImages.refresh();
      selectedImagesPathEdit.add(basename(image.path));
      selectedImagesPathEdit.refresh();
      print(selectedImages);
      print(selectedImagesPathEdit.toString() + "post edit");
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  void deleteImage(int index) {
    selectedImages.remove(selectedImages[index]);
    selectedImages.refresh();
    selectedImagesPath.remove(selectedImagesPath[index]);
    selectedImages.refresh();
  }

  void deleteImageEdit(int index) {
    if (selectedImagesPath.isEmpty) {
      selectedImages.remove(selectedImages[index]);
      selectedImagesPathEdit.remove(selectedImagesPathEdit[index]);
      print("jalan 1");
    } else if (selectedImagesPathEdit.isNotEmpty &&
        index >= selectedImagesPath.length) {
      selectedImagesOnDeletePath
          .add(selectedImagesPathEdit[index - selectedImagesPath.length]);
      selectedImagesPathEdit
          .remove(selectedImagesPathEdit[index - selectedImagesPath.length]);
      selectedImagesPathEdit.refresh();
      print("jalan 2");
    } else {
      selectedImagesOnDeletePath.add(selectedImagesPath[index]);
      selectedImagesPath.remove(selectedImagesPath[index]);
      selectedImagesPath.refresh();
      print("jalan 3");
    }
    selectedImagesEdit.remove(selectedImagesEdit[index]);
    selectedImagesEdit.refresh();
    selectedImagesOnDeletePath.refresh();
    print(selectedImagesOnDeletePath);
  }

  Future pickDate(BuildContext context) async {
    try {
      final newDate = await showDatePicker(
        context: context,
        initialDate: date.value,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now(),
      );
      if (newDate == null) return;
      date.value = newDate;
      dateController.text = DateFormat('dd MMMM yyyy').format(newDate);
    } catch (e) {
      print(e);
      errorMsg("Tidak dapat memilih tanggal. Hubungi customer service kami.");
    }
  }

  void radioButtonMediaSosialOnChanged(String value) {
    mediaSosial.value = value;
  }

  void radioButtonCategoryOnChanged(String value) {
    category.value = value;
  }

  Future errorMsg(String msg) async {
    Get.defaultDialog(
      title: "TERJADI KESALAHAN",
      middleText: msg,
    ).then((value) => Get.offAllNamed(Routes.MAIN));
  }

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments != 0) {
      post.value = Get.arguments;
      judulController.text = post.value.title!;
      deskripsiController.text = post.value.description!;
      category.value = post.value.typePost!;
      kronologiController.text = post.value.chronology!;
      dateController.text = post.value.date!;
      mediaSosialController.text = post.value.socialMedia!;
      mediaSosial.value = post.value.socialMediaType!;
      if (post.value.typePost! == "Found") {
        pertanyaanController.text = post.value.questions![0].question!;
      }
      post.value.imgUrl!.forEach((element) {
        selectedImagesPath.add(element);
        selectedImagesEdit.add(Image.network(element));
      });
      print(selectedImagesPath);
      print(selectedImagesEdit);
    }
    super.onInit();
  }

  @override
  void onClose() {
    judulController.dispose();
    deskripsiController.dispose();
    kronologiController.dispose();
    mediaSosialController.dispose();
    dateController.dispose();
    pertanyaanController.dispose();
    super.onClose();
  }
}
