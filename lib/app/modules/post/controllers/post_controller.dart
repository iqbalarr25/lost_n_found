import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final List<String> mediaSosials = ["Whatsapp", "Instagram", "Line"];
  final List<String> categorys = ["Lost", "Found"];
  var mediaSosial = "".obs;
  var category = "".obs;

  var date = DateTime.now().obs;
  TextEditingController dateController = TextEditingController();

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: date.value,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (newDate == null) return;
    date.value = newDate;
    dateController.text = "${newDate.month}/${newDate.day}/${newDate.year}";
  }

  void radioButtonMediaSosialOnChanged(String value) {
    mediaSosial.value = value;
  }

  void radioButtonCategoryOnChanged(String value) {
    category.value = value;
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
