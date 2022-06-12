import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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
  final box = GetStorage();
  TextEditingController balasanController = TextEditingController();
  var post = MyPost().obs;
  var detailLaporan = MyPost().obs;
  var currentPos = 0.obs;
  var isZoomImage = false.obs;

  late Future<Rx<MyPost>> tampilDetailLaporanFuture;

  Future<Rx<MyPost>> tampilDetailLaporan() async {
    print("PROSES TAMPIL LAPORAN");
    Uri uri;
    if (post.value.userId == box.read("dataUser")["userId"]) {
      if (post.value.typePost == "Found") {
        uri = Uri.parse(
            AuthController.url + "posts/found/my-post/" + post.value.id!);
      } else {
        uri = Uri.parse(
            AuthController.url + "posts/lost/my-post/" + post.value.id!);
      }
    } else {
      uri = Uri.parse(AuthController.url + "posts/" + post.value.id!);
    }

    try {
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + box.read("dataUser")["token"],
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
          print(detailLaporan);
        }
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat menampilkan laporan. Hubungi customer service kami.");
    }
    return detailLaporan;
  }

  Future deleteLaporan() async {
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
      var response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + box.read("dataUser")["token"],
        },
        body: json.encode({"activeStatus": false, "deleteStatus": true}),
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 200) {
        print("BERHASIL Hapus Laporan yang ber-ID : $post.value.id");
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Berhasil menghapus laporan.",
        ).then((value) {
          Get.reloadAll();
          Get.offAllNamed(Routes.MAIN, arguments: 0);
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

  Future kirimPertanyaan() async {
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
    Uri uri = Uri.parse(AuthController.url + "questions");
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + box.read("dataUser")["token"],
        },
        body: json.encode({
          "userId": box.read("dataUser")["userId"],
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
          title: "BERHASIL",
          middleText: "Berhasil mengirim pertanyaan.",
        ).then((value) {
          Get.reloadAll();
          Get.offAllNamed(Routes.MAIN, arguments: 0);
        });
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "TERJADI KESALAHAN",
        middleText:
            "Tidak dapat mengirim pertanyaan, hubungi customer service kami.",
      );
    }
  }

  Future kirimJawaban() async {
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
    Uri uri = Uri.parse(AuthController.url + "answers");
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + box.read("dataUser")["token"],
        },
        body: json.encode({
          "questionId": detailLaporan.value.questions![0].id,
          "userId": box.read("dataUser")["userId"],
          "answer": balasanController.text,
          "statusAnswer": "Waiting"
        }),
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 201) {
        print("BERHASIL menambahkan jawaban");
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Berhasil mengirim jawaban.",
        ).then((value) {
          Get.reloadAll();
          Get.offAllNamed(Routes.MAIN, arguments: 0);
        });
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "TERJADI KESALAHAN",
        middleText:
            "Tidak dapat mengirim jawaban, hubungi customer service kami.",
      );
    }
  }

  Future kirimJawabanBalasan(MyQuestions questions) async {
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
    Uri uri = Uri.parse(AuthController.url + "answers");
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + box.read("dataUser")["token"],
        },
        body: json.encode({
          "questionId": questions.id,
          "userId": box.read("dataUser")["userId"],
          "answer": balasanController.text,
          "statusAnswer": "Waiting"
        }),
      );

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 201) {
        print("BERHASIL menambahkan jawaban");

        uri = Uri.parse(AuthController.url + "questions/" + questions.id!);
        var response = await http.patch(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Accept": "application/json",
            'Authorization': 'Bearer ' + box.read("dataUser")["token"],
          },
          body: json.encode({"statusQuestion": "Answered"}),
        );

        body = json.decode(response.body) as Map<String, dynamic>;
        statusCode = response.statusCode;

        if (statusCode == 200) {
          defaultDialog = Get.defaultDialog(
            title: "BERHASIL",
            middleText: "Berhasil mengirim jawaban.",
          ).then((value) {
            Get.reloadAll();
            Get.toNamed(Routes.MAIN, arguments: 0);
          });
        } else {
          throw "Error : $statusCode";
        }
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "TERJADI KESALAHAN",
        middleText:
            "Tidak dapat mengirim jawaban, hubungi customer service kami.",
      );
    }
  }

  Future interaksiJawabanBalasan(MyAnswers answers, bool accepted) async {
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
    Uri uri;
    try {
      print("BERHASIL menambahkan jawaban");

      uri = (accepted)
          ? Uri.parse(AuthController.url + "posts/found/accept")
          : Uri.parse(AuthController.url + "posts/found/reject");
      var response;
      if (accepted) {
        response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Accept": "application/json",
            'Authorization': 'Bearer ' + box.read("dataUser")["token"],
          },
          body: json.encode({
            "postId": detailLaporan.value.id,
            "questionId": detailLaporan.value.questions![0].id!,
            "answerId": answers.id!
          }),
        );
      } else {
        response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Accept": "application/json",
            'Authorization': 'Bearer ' + box.read("dataUser")["token"],
          },
          body: json.encode({"answerId": answers.id!}),
        );
      }
      if (!accepted) {
        tampilDetailLaporan();
      }

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        defaultDialog = Get.defaultDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
          title: "BERHASIL",
          middleText: (accepted)
              ? "Berhasil menerima jawaban\nSilahkan tunggu penjawab melakukan kontak"
              : "Berhasil menolak balasan.",
        ).then((value) {
          if (accepted) {
            Get.reloadAll();
            Get.toNamed(Routes.MAIN);
          } else {
            Get.back();
            Get.back();
          }
        });
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "TERJADI KESALAHAN",
        middleText:
            "Gagal melakukan interaksi balasan, hubungi customer service kami.",
      );
    }
  }

  void errorMsg(String msg) {
    Get.defaultDialog(
      title: "TERJADI KESALAHAN",
      middleText: msg,
    );
    Get.offAllNamed(Routes.MAIN);
  }

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != 0 && Get.arguments != null) {
      post.value = Get.arguments;
    }
    tampilDetailLaporanFuture = tampilDetailLaporan();
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
