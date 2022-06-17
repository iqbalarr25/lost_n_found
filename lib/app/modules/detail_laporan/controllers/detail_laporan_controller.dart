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

  var isLoading = false.obs;
  var textBottomSheet = "".obs;
  var isFollowedPost = false.obs;

  late Future<Rx<MyPost>> tampilDetailLaporanFuture;

  Future<Rx<MyPost>> tampilDetailLaporan() async {
    print("PROSES TAMPIL LAPORAN");
    Uri uri;
    if (post.value.userId == box.read("dataUser")["userId"] &&
        post.value.activeStatus!) {
      if (post.value.typePost == "Found") {
        uri = Uri.parse(
            AuthController.url + "posts/found/my-post/" + post.value.id!);
      } else {
        uri = Uri.parse(
            AuthController.url + "posts/lost/my-post/" + post.value.id!);
      }
      try {
        isLoading.value = true;
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
      isLoading.value = false;
      return detailLaporan;
    } else {
      return detailLaporan = post;
    }
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
          Get.offAllNamed(Routes.MAIN, arguments: 0);
          Get.reloadAll();
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
    Uri uri;
    if (!isFollowedPost.value) {
      uri = Uri.parse(AuthController.url + "questions");
    } else {
      uri = Uri.parse(
          AuthController.url + "questions/" + post.value.questions![0].id!);
    }
    try {
      var response;
      if (!isFollowedPost.value) {
        response = await http.post(
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
      } else {
        response = await http.patch(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Accept": "application/json",
            'Authorization': 'Bearer ' + box.read("dataUser")["token"],
          },
          body: json.encode({
            "question": balasanController.text,
          }),
        );
      }

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 201 || statusCode == 200) {
        print("BERHASIL menambahkan pertanyaan");
        defaultDialog = Get.defaultDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
          title: "BERHASIL",
          middleText: "Berhasil mengirim pertanyaan.",
        ).then((value) {
          Get.offAllNamed(Routes.MAIN, arguments: 0);
          Get.reloadAll();
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
    Uri uri;
    if (!isFollowedPost.value) {
      uri = Uri.parse(AuthController.url + "answers");
    } else {
      uri = Uri.parse(AuthController.url +
          "answers/" +
          post.value.questions![0].answers![0].id!);
    }
    try {
      var response;
      if (!isFollowedPost.value) {
        response = await http.post(
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
      } else {
        response = await http.patch(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Accept": "application/json",
            'Authorization': 'Bearer ' + box.read("dataUser")["token"],
          },
          body: json.encode({
            "answer": balasanController.text,
          }),
        );
      }

      var body = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = response.statusCode;

      print("STATUS CODE : $statusCode");
      print(body);

      if (statusCode == 201 || statusCode == 200) {
        print("BERHASIL menambahkan jawaban");
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: "Berhasil mengirim jawaban.",
        ).then((value) {
          Get.offAllNamed(Routes.MAIN, arguments: 0);
          Get.reloadAll();
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

  Future kirimJawabanBalasan(MyQuestions question) async {
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
    Uri uri = Uri.parse(AuthController.url + "posts/lost/answer");
    try {
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization': 'Bearer ' + box.read("dataUser")["token"],
        },
        body: json.encode({
          "questionId": question.id,
          "answer": balasanController.text,
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
        ).then((value) async {
          Get.back();
          Get.back();
          isLoading.value = true;
          await (tampilDetailLaporanFuture = tampilDetailLaporan());
          isLoading.value = false;
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
            Get.toNamed(Routes.MAIN);
            Get.reloadAll();
          } else {
            tampilDetailLaporanFuture = tampilDetailLaporan();
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

  void detailLaporanManager() {
    if (post.value.userId != box.read("dataUser")["userId"]) {
      if (!post.value.activeStatus!) {
        textBottomSheet.value = "Laporan selesai";
      } else if (post.value.typePost! == "Found") {
        if (!post.value.questions![0].answers.isBlank!) {
          if (post.value.questions![0].answers![0].userId ==
              box.read("dataUser")["userId"]) {
            textBottomSheet.value = "Edit Jawaban Anda";
            balasanController.text =
                post.value.questions![0].answers![0].answer!;
            isFollowedPost.value = true;
          }
        } else {
          textBottomSheet.value = "Saya Pemiliknya";
        }
      } else {
        if (!post.value.questions.isBlank!) {
          if (post.value.questions![0].userId ==
              box.read("dataUser")["userId"]) {
            if (post.value.questions![0].statusQuestion == "Answered") {
              textBottomSheet.value = "Konfirmasi Jawaban Pelapor";
              isFollowedPost.value = true;
            } else {
              textBottomSheet.value = "Edit Pertanyaan Anda";
              balasanController.text = post.value.questions![0].question!;
              isFollowedPost.value = true;
            }
          }
        } else {
          textBottomSheet.value = "Saya Menemukan";
        }
      }
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
    detailLaporanManager();
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
