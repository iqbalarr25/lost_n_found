import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

import '../controllers/post_controller.dart';

enum MediaSosial { Whatsapp, Instagram, Line }

class PostView extends GetView<PostController> {
  final _formKey = GlobalKey<FormState>();
  final MediaSosial _mediaSosial = MediaSosial.Whatsapp;
  @override
  PostController get controller => super.controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post laporan',
          style: textAppBar,
        ),
        backgroundColor: primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(right: 16, left: 16),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    judul: "Judul barang",
                    hint: "Masukkan nama barang",
                    expands: false,
                    hintSecondary: "",
                  ),
                  TextField(
                    judul: "Deskripsi",
                    hint: "Masukkan deskripsi",
                    expands: true,
                    hintSecondary: "",
                  ),
                  radioCategory(),
                  if (controller.category.value.isNotEmpty) ...[
                    TextField(
                      judul: "Kronologi",
                      hint: "Masukkan kronologi",
                      expands: true,
                      hintSecondary: "",
                    ),
                    TextFieldDate(
                      judul: "Tanggal",
                      hint: "Masukkan tanggal",
                      expands: false,
                      context: context,
                    ),
                    radioMediaSosial(),
                    if (controller.mediaSosial.value != "")
                      TextField(
                        judul: controller.mediaSosial.value,
                        hint: "Masukkan ${controller.mediaSosial.value}",
                        expands: false,
                        hintSecondary: "",
                      ),
                    if (controller.category.value == "Found" &&
                        controller.mediaSosial.value != "")
                      TextField(
                        judul: "Pertanyaan",
                        hint: "Masukkan pertanyaan validasi",
                        expands: true,
                        hintSecondary:
                            "*hint: Pertanyaan seputar barang dapat bersifat unik dan tidak tercantum pada deskripsi/kronologi",
                      ),
                  ],
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: primaryColor),
                      child: Center(
                        child: Text(
                          "Kirim",
                          style: textWhiteMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget TextField(
      {required String judul,
      required String hint,
      required bool expands,
      required String hintSecondary}) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: textBlackMedium,
          ),
          const SizedBox(
            height: 7,
          ),
          (expands == true)
              ? ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 130),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: hint,
                      isDense: true,
                      hintStyle: textHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator:
                        RequiredValidator(errorText: judul + " harus diisi!"),
                  ),
                )
              : TextFormField(
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: hint,
                    isDense: true,
                    hintStyle: textHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  validator:
                      RequiredValidator(errorText: judul + " harus diisi!"),
                ),
          SizedBox(height: 2),
          (hintSecondary != "")
              ? Text(
                  hintSecondary,
                  style: textGreyHintSec,
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget TextFieldDate(
      {required String judul,
      required String hint,
      required bool expands,
      required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: textBlackMedium,
          ),
          const SizedBox(
            height: 7,
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 9,
                  child: TextFormField(
                    onTap: () => controller.pickDate(context),
                    controller: controller.dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: hint,
                      isDense: true,
                      hintStyle: textHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator:
                        RequiredValidator(errorText: judul + " harus diisi!"),
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.pickDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: FittedBox(
                      child: Icon(
                        Icons.date_range,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget radioMediaSosial() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Radio<String>(
                activeColor: primaryColor,
                value: controller.mediaSosials[0],
                groupValue: controller.mediaSosial.value,
                onChanged: (value) =>
                    controller.radioButtonMediaSosialOnChanged(value!),
              ),
              Text(
                controller.mediaSosials[0],
                style: textBlackSmall,
              ),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                activeColor: primaryColor,
                value: controller.mediaSosials[1],
                groupValue: controller.mediaSosial.value,
                onChanged: (value) =>
                    controller.radioButtonMediaSosialOnChanged(value!),
              ),
              Text(
                controller.mediaSosials[1],
                style: textBlackSmall,
              ),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                activeColor: primaryColor,
                value: controller.mediaSosials[2],
                groupValue: controller.mediaSosial.value,
                onChanged: (value) =>
                    controller.radioButtonMediaSosialOnChanged(value!),
              ),
              Text(
                controller.mediaSosials[2],
                style: textBlackSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget radioCategory() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Radio<String>(
                activeColor: primaryColor,
                value: controller.categorys[0],
                groupValue: controller.category.value,
                onChanged: (value) =>
                    controller.radioButtonCategoryOnChanged(value!),
              ),
              Text(
                controller.categorys[0],
                style: textBlackSmall,
              ),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                activeColor: primaryColor,
                value: controller.categorys[1],
                groupValue: controller.category.value,
                onChanged: (value) =>
                    controller.radioButtonCategoryOnChanged(value!),
              ),
              Text(
                controller.categorys[1],
                style: textBlackSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
