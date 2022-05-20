import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';

class HomeController extends GetxController {
  var selectedItem = 0.obs;

  var laporanAnda = List<Post>.empty().obs;
  var laporanDiikuti = List<Post>.empty().obs;

  Future tampilPostLaporanAnda() async {
    laporanAnda = List<Post>.empty().obs;
    print("PROSES TAMPIL POSTING");
    Uri uri = Uri.parse(AuthController.url + "posts/my-post");
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
        print("BERHASIL MENAMPILKAN LAPORAN");

        if (body['data'] != null) {
          var laporanAndas = body['data'] as List<dynamic>;
          laporanAndas.forEach(
            (element) {
              laporanAnda.add(Post.fromJson(element as Map<String, dynamic>));
            },
          );
          print("jumlah laporan anda: " + laporanAnda.length.toString());
        }

        laporanAnda.refresh();
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat menampilkan laporan. Hubungi customer service kami.");
    }
  }

  Future tampilPostFollowing() async {
    laporanDiikuti = List<Post>.empty().obs;
    print("PROSES TAMPIL POSTING FOLLOWING");
    Uri uri = Uri.parse(AuthController.url + "posts/following");
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
        print("BERHASIL MENAMPILKAN LAPORAN");

        if (body['data'] != null) {
          var laporanDiikutis = body['data'] as List<dynamic>;
          laporanDiikutis.forEach(
            (element) {
              laporanDiikuti
                  .add(Post.fromJson(element as Map<String, dynamic>));
            },
          );
          print(
              "jumlah laporan following: " + laporanDiikuti.length.toString());
        }

        laporanDiikuti.refresh();
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat menampilkan laporan. Hubungi customer service kami.");
    }
  }

  void errorMsg(String msg) {
    Get.defaultDialog(
      title: "TERJADI KESALAHAN",
      middleText: msg,
    );
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
