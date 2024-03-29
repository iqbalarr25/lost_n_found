import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/data/models/history_model.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:lost_n_found/app/themes/theme_app.dart';

class HistoryController extends GetxController {
  var isLoading = false.obs;
  var laporanHistory = History().obs;

  var historyAllPost = List<MyPost>.empty().obs;
  var followingFoundPost = List<MyPost>.empty().obs;
  var followingLostPost = List<MyPost>.empty().obs;
  var ownFoundPost = List<MyPost>.empty().obs;
  var ownLostPost = List<MyPost>.empty().obs;

  var laporanSemuaSelected = true.obs;
  var laporanAndaSelected = false.obs;
  var laporanDiikutiSelected = false.obs;

  late Future<Rx<History>>? tampilPostLaporanHistoryFuture;

  Future<Rx<History>>? tampilPostLaporanHistory() async {
    Uri uri = Uri.parse(AuthController.url + "posts/history");

    laporanHistory = History().obs;
    isLoading.value = true;

    print("PROSES TAMPIL HISTORY");
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
          laporanHistory.value =
              History.fromJson(body['data'] as Map<String, dynamic>);
          if (laporanHistory.value.followingFoundPosts != null) {
            followingFoundPost.value =
                laporanHistory.value.followingFoundPosts!;
          }
          if (laporanHistory.value.followingLostPosts != null) {
            followingLostPost.value = laporanHistory.value.followingLostPosts!;
          }
          if (laporanHistory.value.ownFoundPosts != null) {
            ownFoundPost.value = laporanHistory.value.ownFoundPosts!;
          }
          if (laporanHistory.value.ownLostPosts != null) {
            ownLostPost.value = laporanHistory.value.ownLostPosts!;
          }
          historyAllPost.value = [
            ...followingFoundPost,
            ...followingLostPost,
            ...ownFoundPost,
            ...ownLostPost
          ];
          print("jumlah laporan history: " + historyAllPost.length.toString());
        }
        laporanHistory.refresh();
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
          "Tidak dapat menampilkan history. Hubungi customer service kami.");
    }
    isLoading.value = false;
    return laporanHistory;
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
    });
  }

  void filterBehaviour(
      {bool? laporanSemuaSelected,
      bool? laporanAndaSelected,
      bool? laporanDiikutiSelected}) {
    isLoading.value = true;
    historyAllPost.clear();
    if (laporanSemuaSelected != null) {
      this.laporanSemuaSelected.value = laporanSemuaSelected;
      this.laporanAndaSelected.value = false;
      this.laporanDiikutiSelected.value = false;
      historyAllPost.value = [
        ...ownLostPost,
        ...ownFoundPost,
        ...followingLostPost,
        ...followingFoundPost
      ];
    }
    if (laporanAndaSelected != null) {
      this.laporanSemuaSelected.value = false;
      this.laporanAndaSelected.value = laporanAndaSelected;
      this.laporanDiikutiSelected.value = false;
      historyAllPost.value = [
        ...ownLostPost,
        ...ownFoundPost,
      ];
    }
    if (laporanDiikutiSelected != null) {
      this.laporanSemuaSelected.value = false;
      this.laporanAndaSelected.value = false;
      this.laporanDiikutiSelected.value = laporanDiikutiSelected;
      historyAllPost.value = [...followingLostPost, ...followingFoundPost];
    }
    isLoading.value = false;
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
    tampilPostLaporanHistoryFuture = tampilPostLaporanHistory();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
