import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MainController extends GetxController {
  var args = Get.arguments;
  var selectedIndex = 0.obs;
  final count = 0.obs;

  // var _client;
  // var _streamResponse;

  // Future<dynamic> streamFiles() async {
  //   _client = http.Client();
  //   final url = 'url';
  //   var headers = {
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     "Accept": "application/json",
  //     'Authorization': 'Bearer ' + AuthController.box.read("dataUser")["token"],
  //   };

  //   final req = http.Request('GET', Uri.parse(url));
  //   req.headers.addAll(headers);
  //   final res = await _client.send(req);

  //   _streamResponse = res.stream.toStringStream().listen((value) {
  //     print(json.decode(value));
  //   });
  // }

  // @override
  // void dispose() {
  //   if (_streamResponse != null) _streamResponse.cancel();
  //   if (_client != null) _client.close();
  //   super.dispose();
  // }

  @override
  void onInit() {
    if (Get.arguments != null) {
      selectedIndex.value = args;
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
