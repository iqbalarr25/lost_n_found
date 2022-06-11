import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';

import '../../../controllers/auth_controller.dart';
import 'package:http/http.dart' as http;

class NewsController extends GetxController with GetTickerProviderStateMixin {
  final box = GetStorage();
  late TabController tabController =
      TabController(length: 2, vsync: this, initialIndex: thisPage.value);
  var thisPage = 0.obs;

  final scrollControllerLost = ScrollController();
  final scrollControllerFound = ScrollController();

  TextEditingController searchTextLost = TextEditingController();
  TextEditingController searchTextFound = TextEditingController();

  var offsetLost = 0.obs;
  var limitLost = 5.obs;
  var offsetFound = 0.obs;
  var limitFound = 5.obs;

  var isLoadingLost = false.obs;
  var isLoadingFound = false.obs;
  var isLoadingLostBottom = false.obs;
  var isLoadingFoundBottom = false.obs;

  var laporanNewsFound = List<MyPost>.empty().obs;
  var laporanNewsLost = List<MyPost>.empty().obs;

  late Future<RxList<MyPost>>? tampilPostLaporanNewsLost;
  late Future<RxList<MyPost>>? tampilPostLaporanNewsFound;

  Future<RxList<MyPost>>? tampilPostLaporanNews(int page) async {
    Uri uri;
    if (page == 0) {
      if (searchTextLost.text == "") {
        uri = Uri.parse(AuthController.url +
            "posts/lost/news?offset=$offsetLost&limit=$limitLost");
      } else {
        uri = Uri.parse(AuthController.url +
            "posts/lost/lost/search?filter=${searchTextLost.text}");
      }
      if (offsetLost.value == 0) {
        isLoadingLost.value = true;
      } else {
        isLoadingLostBottom.value = true;
      }
    } else {
      if (searchTextFound.text == "") {
        uri = Uri.parse(AuthController.url +
            "posts/found/news?offset=$offsetFound&limit=$limitFound");
      } else {
        uri = Uri.parse(AuthController.url +
            "posts/found/search?filter=${searchTextFound.text}");
      }
      if (offsetFound.value == 0) {
        isLoadingFound.value = true;
      } else {
        isLoadingFoundBottom.value = true;
      }
    }
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
          var laporanNews = body['data'] as List<dynamic>;
          laporanNews.forEach(
            (element) {
              (page == 0)
                  ? laporanNewsLost
                      .add(MyPost.fromJson(element as Map<String, dynamic>))
                  : laporanNewsFound
                      .add(MyPost.fromJson(element as Map<String, dynamic>));
            },
          );
          print("jumlah laporan hilang: " + laporanNewsLost.length.toString());
          print("jumlah laporan temu: " + laporanNewsFound.length.toString());
        }

        laporanNewsLost.refresh();
        laporanNewsFound.refresh();
      } else {
        throw "Error : $statusCode";
      }
    } catch (e) {
      print(e);
      errorMsg(
          "Tidak dapat menampilkan laporan. Hubungi customer service kami.");
    }
    if (page == 0) {
      isLoadingLost.value = false;
      if (offsetLost.value != 0) isLoadingLostBottom.value = false;
      return laporanNewsLost;
    } else {
      isLoadingFound.value = false;
      if (offsetFound.value != 0) isLoadingFoundBottom.value = false;
      return laporanNewsFound;
    }
  }

  Future refreshTab(int tabIndex) async {
    if (tabIndex == 0) {
      offsetLost.value = 0;
      limitLost.value = 5;
      laporanNewsLost.clear();
    } else {
      offsetFound.value = 0;
      limitFound.value = 5;
      laporanNewsFound.clear();
    }
    await (tampilPostLaporanNewsLost = tampilPostLaporanNews(tabIndex));
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
    tampilPostLaporanNewsLost = tampilPostLaporanNews(0);
    tampilPostLaporanNewsFound = tampilPostLaporanNews(1);
    tabController.addListener(
      () {
        thisPage.value = tabController.index;
      },
    );
    scrollControllerLost.addListener(() {
      if (scrollControllerLost.position.maxScrollExtent ==
              scrollControllerLost.offset &&
          !isLoadingLostBottom.value &&
          searchTextLost.text.isEmpty) {
        offsetLost.value += laporanNewsLost.length;
        limitLost.value += 5;
        tampilPostLaporanNewsLost = tampilPostLaporanNews(0);
      }
    });
    scrollControllerFound.addListener(() {
      if (scrollControllerFound.position.maxScrollExtent ==
              scrollControllerFound.offset &&
          !isLoadingFoundBottom.value &&
          searchTextFound.text.isEmpty) {
        offsetFound.value += laporanNewsFound.length;
        limitFound.value += 5;
        tampilPostLaporanNewsFound = tampilPostLaporanNews(1);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
