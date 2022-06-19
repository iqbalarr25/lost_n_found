import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';
import 'package:lost_n_found/app/data/models/questions_model.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  late Future<RxList<MyPost>>? tampilPostLaporanAndaFuture;
  late Future<RxList<MyPost>>? tampilPostFollowingFuture;

  var laporanAnda = List<MyPost>.empty().obs;
  var laporanDiikuti = List<MyPost>.empty().obs;

  Future<RxList<MyPost>>? tampilPostLaporanAnda() async {
    laporanAnda = List<MyPost>.empty().obs;
    print("PROSES TAMPIL POSTING");
    Uri uri = Uri.parse(AuthController.url + "posts/my-post");
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
        print("BERHASIL MENAMPILKAN LAPORAN");

        if (body['data'] != null) {
          var laporanAndas = body['data'] as List<dynamic>;
          laporanAndas.forEach(
            (element) {
              laporanAnda.add(MyPost.fromJson(element as Map<String, dynamic>));
            },
          );
          print("jumlah laporan anda: " + laporanAnda.length.toString());
        }

        laporanAnda.refresh();
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
          "Tidak dapat menampilkan laporan anda. Hubungi customer service kami.");
    }
    return laporanAnda;
  }

  Future<RxList<MyPost>>? tampilPostFollowing() async {
    laporanDiikuti = List<MyPost>.empty().obs;
    print("PROSES TAMPIL POSTING FOLLOWING");
    Uri uri = Uri.parse(AuthController.url + "posts/following");
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
        print("BERHASIL MENAMPILKAN LAPORAN");

        if (body['data'] != null) {
          var laporanDiikutis = body['data'] as List<dynamic>;
          laporanDiikutis.forEach(
            (element) {
              laporanDiikuti
                  .add(MyPost.fromJson(element as Map<String, dynamic>));
            },
          );
          print(
              "jumlah laporan following: " + laporanDiikuti.length.toString());
        }
        laporanDiikuti.refresh();
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
          "Tidak dapat menampilkan laporan yang anda ikuti. Hubungi customer service kami.");
    }
    return laporanDiikuti;
  }

  Future interaksiPostFollowing(MyPost post, MyQuestions questions,
      bool isAccepted, BuildContext context) async {
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

      uri = (isAccepted)
          ? Uri.parse(AuthController.url + "posts/lost/finish")
          : Uri.parse(AuthController.url + "posts/lost/reject");
      http.Response response;
      if (isAccepted) {
        response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Accept": "application/json",
            'Authorization':
                'Bearer ' + AuthController.box.read("dataUser")["token"],
          },
          body: json.encode({
            "postId": post.id,
            "questionId": questions.id,
            "answerId": questions.answers![0].id
          }),
        );
      } else {
        response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Accept": "application/json",
            'Authorization':
                'Bearer ' + AuthController.box.read("dataUser")["token"],
          },
          body: json.encode({
            "questionId": questions.id,
            "answerId": questions.answers![0].id
          }),
        );
      }

      var statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        defaultDialog = Get.defaultDialog(
          title: "BERHASIL",
          middleText: (isAccepted)
              ? "Berhasil menerima jawaban\nSilahkan kontak pelapor barang"
              : "Berhasil menolak balasan.",
        ).then((value) async {
          Get.back();
          Get.back();
          if (isAccepted) {
            openDialogKontak(post, context);
          } else {
            isLoading.value = true;
            await (tampilPostFollowingFuture = tampilPostFollowing());
            isLoading.value = false;
          }
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
      Get.defaultDialog(
        title: "TERJADI KESALAHAN",
        middleText:
            "Gagal melakukan interaksi balasan, hubungi customer service kami.",
      );
    }
  }

  Future openDialogKontak(MyPost post, BuildContext context) async {
    var isCopy = false.obs;

    Get.defaultDialog(
      barrierDismissible: true,
      title: "Kontak pelapor",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Column(
        children: [
          const SizedBox(height: 15),
          FittedBox(
            child: Text(
              post.user!.name!.capitalize!,
              style: textBlackSmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 5),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            backgroundImage: const AssetImage("assets/images/avatar.jpg"),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
              backgroundImage: (post.user!.imgUrl != null)
                  ? NetworkImage(post.user!.imgUrl!)
                  : const AssetImage("assets/images/avatar.jpg")
                      as ImageProvider,
            ),
          ),
          FittedBox(
            child: Text(
              post.socialMediaType!,
              style: textBlackMedium,
            ),
          ),
          FittedBox(
            child: Text(
              post.socialMedia!,
              style: textGreyMediumNormal,
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: post.socialMedia!)).then(
                (value) {
                  isCopy.value = true;
                  Get.back();
                },
              );
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  "Salin",
                  style: textWhiteMedium,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    ).then((value) async {
      if (isCopy.value) {
        Get.snackbar("Behasil", "Kontak berhasil disalin!",
            snackPosition: SnackPosition.BOTTOM);
      }
      isLoading.value = true;
      await (tampilPostFollowingFuture = tampilPostFollowing());
      isLoading.value = false;
    });
  }

  Future followingFoundFinish(
      MyPost post, MyQuestions questions, BuildContext context) async {
    print("lagi coba");
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
      Uri uri = Uri.parse(AuthController.url + "posts/found/finish");
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          'Authorization':
              'Bearer ' + AuthController.box.read("dataUser")["token"],
        },
        body: json.encode({
          "postId": post.id,
          "questionId": questions.id,
          "answerId": questions.answers![0].id
        }),
      );
      var statusCode = response.statusCode;

      if (statusCode == 201) {
        Get.back();
        openDialogKontak(post, context);
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
    ).then((value) {
      Get.back();
      Get.back();
    });
  }

  @override
  void onInit() {
    super.onInit();
    tampilPostLaporanAndaFuture = tampilPostLaporanAnda();
    tampilPostFollowingFuture = tampilPostFollowing();
  }

  @override
  void onReady() {
    super.onReady();
    print(AuthController.box.read("dataUser"));
  }

  @override
  void onClose() {}
}
