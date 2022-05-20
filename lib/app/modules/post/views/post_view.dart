import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';
import '../controllers/post_controller.dart';

class PostView extends GetView<PostController> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (controller.post.value.id == null) ? 'Post laporan' : 'Edit laporan',
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
                    textController: controller.judulController,
                  ),
                  TextField(
                    judul: "Deskripsi",
                    hint: "Masukkan deskripsi",
                    expands: true,
                    hintSecondary: "",
                    textController: controller.deskripsiController,
                  ),
                  radioCategory(),
                  if (controller.category.value.isNotEmpty) ...[
                    TextField(
                      judul: "Kronologi",
                      hint: "Masukkan kronologi",
                      expands: true,
                      hintSecondary: "",
                      textController: controller.kronologiController,
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
                        textController: controller.mediaSosialController,
                      ),
                    if (controller.category.value == "Found" &&
                        controller.mediaSosial.value != "")
                      TextField(
                        judul: "Pertanyaan",
                        hint: "Masukkan pertanyaan validasi",
                        expands: true,
                        hintSecondary:
                            "*hint: Pertanyaan seputar barang dapat bersifat unik dan tidak tercantum pada deskripsi/kronologi",
                        textController: controller.pertanyaanController,
                      ),
                    if (controller.mediaSosial.value != "")
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Stack(
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: lightGreyColor,
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: Column(
                                children: [
                                  Obx(
                                    () => Expanded(
                                      flex: 9,
                                      child: (controller.post.value.id == null)
                                          ? (controller
                                                  .selectedImages.isNotEmpty)
                                              ? listSelectedImage()
                                              : Container(
                                                  padding:
                                                      EdgeInsets.only(top: 16),
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 75,
                                                    color: whiteColor,
                                                  ),
                                                )
                                          : (controller.selectedImagesEdit
                                                  .isNotEmpty)
                                              ? listSelectedImage()
                                              : Container(
                                                  padding:
                                                      EdgeInsets.only(top: 16),
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 75,
                                                    color: whiteColor,
                                                  ),
                                                ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                tileColor: Colors.white,
                                                leading: new Icon(Icons.photo),
                                                title: new Text('Gallery'),
                                                onTap: () {
                                                  if (controller
                                                          .post.value.id ==
                                                      null) {
                                                    controller.pickImageNormal(
                                                        ImageSource.gallery);
                                                  } else {
                                                    controller.pickImageEdit(
                                                        ImageSource.gallery);
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                tileColor: Colors.white,
                                                leading:
                                                    new Icon(Icons.camera_alt),
                                                title: new Text('Camera'),
                                                onTap: () {
                                                  if (controller
                                                          .post.value.id ==
                                                      null) {
                                                    controller.pickImageNormal(
                                                        ImageSource.camera);
                                                  } else {
                                                    controller.pickImageEdit(
                                                        ImageSource.camera);
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: primaryColor),
                                        child: Center(
                                          child: Text(
                                            "Upload gambar",
                                            style: textWhiteMedium,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                  if (controller.mediaSosial.value != "")
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (controller.post.value.id == null) {
                              if (controller.selectedImages.isNotEmpty) {
                                print("tambah post");
                                controller.tambahPost();
                              } else {
                                controller
                                    .errorMsg("Gambar tidak boleh kosong!");
                              }
                            } else {
                              if (controller
                                  .selectedImagesPathEdit.isNotEmpty) {
                                print("edit post");
                                controller.editPost();
                              } else {
                                controller
                                    .errorMsg("Gambar tidak boleh kosong!");
                              }
                            }
                          }
                        },
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
      required String hintSecondary,
      required TextEditingController textController}) {
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
                  constraints: const BoxConstraints(maxHeight: 130),
                  child: TextFormField(
                    controller: textController,
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
                  controller: textController,
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

  Widget listSelectedImage() {
    return ListView.builder(
      itemCount: (controller.post.value.id == null)
          ? controller.selectedImages.length
          : controller.selectedImagesEdit.length,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, i) => Stack(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 115,
              decoration: BoxDecoration(
                color: blackColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: (controller.post.value.id == null)
                  ? Image.file(
                      File(
                        controller.selectedImages.value[i].path,
                      ),
                    )
                  : controller.selectedImagesEdit.value[i]),
          GestureDetector(
            onTap: () {
              if (controller.post.value.id == null) {
                controller.deleteImage(i);
              } else {
                controller.deleteImageEdit(i);
              }
            },
            child: SizedBox(
              width: 135,
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 12,
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: whiteColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
