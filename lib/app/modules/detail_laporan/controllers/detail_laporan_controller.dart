import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:get/get.dart';
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/data/models/answers_model.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';
import 'package:lost_n_found/app/data/models/questions_model.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

class DetailLaporanController extends GetxController {
  TextEditingController balasanController = TextEditingController();
  var questions = List<Questions>.empty().obs;
  var answers = List<Answers>.empty().obs;
  var post = Post().obs;
  var detailLaporan = MyPost().obs;
  var currentPos = 0.obs;

  List<String> listPaths = [];

  Future tampilDetailLaporan() async {
    print("PROSES TAMPIL LAPORAN");
    Uri uri;
    if (post.value.typePost == "Found") {
      uri = Uri.parse(
          AuthController.url + "posts/my-post/found/" + post.value.id!);
    } else {
      uri = Uri.parse(
          AuthController.url + "posts/my-post/lost/" + post.value.id!);
    }

    try {
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + AuthController.token,
        },
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 200) {
        print("BERHASIL MENAMPILKAN PERTANYAAN");

        if (body['data'] != null) {
          detailLaporan.value =
              MyPost.fromJson(body['data'] as Map<String, dynamic>);
          print(detailLaporan.value);
          detailLaporan.value.imgUrl!.forEach((element) {
            listPaths.add(element);
          });
        }
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat menampilkan laporan. Hubungi customer service kami.");
    }
  }

  Future deleteLaporan() async {
    var defaultDialog = Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          color: whiteColor,
          child: const CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false,
    );
    Uri uri =
        Uri.parse(AuthController.url + "posts/" + detailLaporan.value.id!);
    try {
      var response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + AuthController.token,
        },
        body: json.encode({"activeStatus": false, "deleteStatus": true}),
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 200) {
        print("BERHASIL Hapus Laporan yang ber-ID : $detailLaporan.value.id");
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Telah berhasil menghapus laporan.",
        ).then((value) {
          Get.reloadAll();
          Get.toNamed(Routes.MAIN, arguments: 0);
        });
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "TERJADI KESALAHAN",
        middleText:
            "Tidak dapat menghapus laporan, hubungi customer service kami.",
      );
    }
  }

  Future tampilPertanyaan() async {
    questions = List<Questions>.empty().obs;
    print("PROSES TAMPIL PERTANYAAN");
    Uri uri = Uri.parse(AuthController.url + "questions");
    try {
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + AuthController.token,
        },
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 200) {
        print("BERHASIL MENAMPILKAN PERTANYAAN");

        if (body['data'] != null) {
          var listQuestion = body['data'] as List<dynamic>;
          listQuestion.forEach(
            (element) {
              if (element['postId'] == post.value.id) {
                questions
                    .add(Questions.fromJson(element as Map<String, dynamic>));
              }
            },
          );
          print("jumlah pertanyaan anda: " + questions.length.toString());
        }

        questions.refresh();
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat menampilkan laporan. Hubungi customer service kami.");
    }
  }

  Future tampilJawaban() async {
    questions = List<Questions>.empty().obs;
    print("PROSES TAMPIL PERTANYAAN");
    Uri uri = Uri.parse(AuthController.url + "answers");
    try {
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + AuthController.token,
        },
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 200) {
        print("BERHASIL MENAMPILKAN JAWABAN");

        if (body['data'] != null) {
          var listAnswer = body['data'] as List<dynamic>;
          listAnswer.forEach(
            (element) {
              answers.add(Answers.fromJson(element as Map<String, dynamic>));
            },
          );
          print("jumlah pertanyaan anda: " + questions.length.toString());
        }

        questions.refresh();
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat menampilkan laporan. Hubungi customer service kami.");
    }
  }

  Future kirimPertanyaan() async {
    var defaultDialog = Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          color: whiteColor,
          child: const CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false,
    );
    Uri uri = Uri.parse(AuthController.url + "questions");
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + AuthController.token,
        },
        body: json.encode({
          "userId": AuthController.userId,
          "postId": post.value.id,
          "typeQuestion": "UserQuestion",
          "question": balasanController.text,
          "statusQuestion": "Waiting"
        }),
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 201) {
        print("BERHASIL menambahkan pertanyaan");
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Telah berhasil mengirim pertanyaan.",
        ).then((value) {
          Get.reloadAll();
          Get.toNamed(Routes.MAIN, arguments: 0);
        });
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "TERJADI KESALAHAN",
        middleText:
            "Tidak dapat menghapus laporan, hubungi customer service kami.",
      );
    }
  }

  void errorMsg(String msg) {
    Get.defaultDialog(
      title: "TERJADI KESALAHAN",
      middleText: msg,
    );
  }

  final count = 0.obs;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments != 0) {
      post.value = Get.arguments;
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
