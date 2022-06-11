import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:lost_n_found/app/themes/theme_app.dart';

class HistoryController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var laporanHistory = List<MyPost>.empty().obs;

  late Future<RxList<MyPost>>? tampilPostLaporanHistoryFuture;

  Future<RxList<MyPost>>? tampilPostLaporanHistory() async {
    Uri uri = Uri.parse(AuthController.url + "posts/history");

    laporanHistory = List<MyPost>.empty().obs;
    isLoading.value = true;

    print("PROSES TAMPIL POSTING");
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
        print("BERHASIL MENAMPILKAN LAPORAN");

        if (body['data'] != null) {
          var laporanHistories = body['data'] as List<dynamic>;
          laporanHistories.forEach(
            (element) {
              laporanHistory
                  .add(MyPost.fromJson(element as Map<String, dynamic>));
            },
          );
          print("jumlah laporan history: " + laporanHistory.length.toString());
        }
        laporanHistory.refresh();
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
      title: "Kontak pelapor",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Column(
        children: [
          const SizedBox(height: 15),
          Text(
            "Iqbal Arrafi",
            style: textBlackSmall,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            post.socialMediaType!,
            style: textBlackMedium,
          ),
          Text(
            post.socialMedia!,
            style: textGreyMediumNormal,
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
