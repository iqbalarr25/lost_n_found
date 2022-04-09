import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

import '../controllers/detail_laporan_controller.dart';

class DetailLaporanView extends GetView<DetailLaporanController> {
  @override
  Widget build(BuildContext context) {
    return userNormal();
  }

  Widget userNormal() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail laporan',
          style: textAppBar,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider.builder(
                  itemCount: controller.listPaths.length,
                  itemBuilder: (context, itemIndex, pageViewIndex) =>
                      controller.listPaths[itemIndex],
                  options: CarouselOptions(
                    height: 230,
                    onPageChanged: (index, reason) {
                      controller.currentPos.value = index;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: controller.listPaths.map((url) {
                    int index = controller.listPaths.indexOf(url);
                    return Obx(
                      () => Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.currentPos.value == index
                              ? primaryColor
                              : whiteColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Material(
              elevation: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Laptop gaming ASUS",
                      style: textBlackBig,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Found",
                        style: textWhiteMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textTitleBody(
                    title: "Deskripsi",
                    body: Text(
                      "Laptop asus warna hitam dengan keyboard RGB jedag-jedug, ada sticker apple nya dibelakang.",
                      style: textGreyDetailLaporan,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  textTitleBody(
                    title: "Kronologi",
                    body: Text(
                      "Terakhir kali saya pakai di telu coffee, setelah saya tinggal ke kosan besoknya saya balik, tetapi laptop saya sudah hilang.",
                      style: textGreyDetailLaporan,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  textTitleBody(
                    title: "Tanggal",
                    body: Text(
                      "11 November 2022",
                      style: textGreyDetailLaporan,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      openDialogMenjawab();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "Saya Pemiliknya",
                          style: textWhiteMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userPemilik() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail laporan',
          style: textAppBar,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider.builder(
                  itemCount: controller.listPaths.length,
                  itemBuilder: (context, itemIndex, pageViewIndex) =>
                      controller.listPaths[itemIndex],
                  options: CarouselOptions(
                    height: 230,
                    onPageChanged: (index, reason) {
                      controller.currentPos.value = index;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: controller.listPaths.map((url) {
                    int index = controller.listPaths.indexOf(url);
                    return Obx(
                      () => Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.currentPos.value == index
                              ? primaryColor
                              : whiteColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Material(
              elevation: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Laptop gaming ASUS",
                      style: textBlackBig,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Found",
                        style: textWhiteMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textTitleBody(
                    title: "Deskripsi",
                    body: Text(
                      "Laptop asus warna hitam dengan keyboard RGB jedag-jedug, ada sticker apple nya dibelakang.",
                      style: textGreyDetailLaporan,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  textTitleBody(
                    title: "Kronologi",
                    body: Text(
                      "Terakhir kali saya pakai di telu coffee, setelah saya tinggal ke kosan besoknya saya balik, tetapi laptop saya sudah hilang.",
                      style: textGreyDetailLaporan,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  textTitleBody(
                    title: "Tanggal",
                    body: Text(
                      "11 November 2022",
                      style: textGreyDetailLaporan,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  textTitleBody(
                    title: "Pertanyaan",
                    body: Text(
                      "Apa warna background laptop",
                      style: textGreyDetailLaporan,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  textTitleBody(
                    title: "Balasan",
                    body: Column(
                      children: [
                        cardBalasan(),
                        cardBalasan(),
                        cardBalasan(),
                        cardBalasan(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardBalasan() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
          height: 55,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: greyColor,
                  shape: BoxShape.circle,
                ),
                width: 50,
              ),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Iqbal Arrafi",
                      style: textWhiteSmallNormal,
                    ),
                    Text(
                      "waifu saya, fu hua blablablablablablaa aaaaaaaaaaaaaa",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textWhiteSmallBalasan,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  "Detail",
                  style: textRedMini,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textTitleBody({required String title, required Widget body}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textBlackMedium,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 5),
        body,
      ],
    );
  }

  Future openDialogAjukanPertanyaan() async {
    Get.defaultDialog(
      title: "Pertanyaan penemu",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Column(
        children: [
          const SizedBox(height: 15),
          Text(
            "Ajukan pertanyaan kepada pemilik",
            style: textBlackSmallNormal,
          ),
          const SizedBox(height: 15),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 130),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.top,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: "Masukkan pertanyaan",
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
                  RequiredValidator(errorText: "Pertanyaan harus diisi!"),
            ),
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "*hint: Pertanyaan seputar barang dapat bersifat unik dan tidak tercantum pada deskripsi/kronologi",
              style: textGreyHintSec,
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              print("Kirim");
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  "Kirim",
                  style: textWhiteMedium,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Future openDialogMenjawab() async {
    Get.defaultDialog(
      title: "Pertanyaan penemu",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Column(
        children: [
          const SizedBox(height: 15),
          Text(
            "1. Apa background dari laptop",
            style: textBlackSmallNormal,
          ),
          const SizedBox(height: 15),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 130),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.top,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: "Masukkan jawaban",
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
                  RequiredValidator(errorText: "Pertanyaan harus diisi!"),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              print("Kirim");
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  "Kirim",
                  style: textWhiteMedium,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
