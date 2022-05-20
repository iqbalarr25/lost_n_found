import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/data/models/answers_model.dart';
import 'package:lost_n_found/app/data/models/questions_model.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';
import '../controllers/detail_laporan_controller.dart';

class DetailLaporanView extends GetView<DetailLaporanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: controller.tampilDetailLaporan(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return buildDetailLaporan();
            }
          }),
    );
  }

  Widget buildDetailLaporan() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail laporan',
          style: textAppBar,
        ),
        actions: [
          if (controller.detailLaporan.value.userId ==
              AuthController.userId) ...[
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.POST,
                    arguments: controller.detailLaporan.value);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                openDialogHapus();
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider.builder(
                  itemCount: controller.listPaths.length,
                  itemBuilder: (context, itemIndex, pageViewIndex) =>
                      Image.network(controller.listPaths[itemIndex]),
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
                      controller.detailLaporan.value.title!.capitalizeFirst!,
                      style: textBlackBig,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        controller.detailLaporan.value.typePost!,
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
                      controller
                          .detailLaporan.value.description!.capitalizeFirst!,
                      style: textGreyDetailLaporan,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  textTitleBody(
                    title: "Kronologi",
                    body: Text(
                      controller
                          .detailLaporan.value.chronology!.capitalizeFirst!,
                      style: textGreyDetailLaporan,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  textTitleBody(
                    title: "Tanggal",
                    body: Text(
                      controller.detailLaporan.value.date!,
                      style: textGreyDetailLaporan,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (controller.detailLaporan.value.typePost == "Found")
                    textTitleBody(
                      title: "Pertanyaan",
                      body: Text(
                        controller.detailLaporan.value.questions![0].question!,
                        style: textGreyDetailLaporan,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (controller.detailLaporan.value.userId ==
                      AuthController.userId) ...[
                    textTitleBody(
                      title: "Balasan",
                      body: FutureBuilder(
                        future:
                            (controller.detailLaporan.value.typePost == "Found")
                                ? controller.tampilJawaban()
                                : controller.tampilPertanyaan(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return Column(
                              children: (controller
                                          .detailLaporan.value.typePost ==
                                      "Found")
                                  ? (controller.detailLaporan.value
                                          .questions![0].answers!.isNotEmpty)
                                      ? controller.detailLaporan.value
                                          .questions![0].answers!
                                          .map((element) =>
                                              buildCardBalasanAnswer(element))
                                          .toList()
                                      : [
                                          Text("Belum ada balasan",
                                              style: textGreyDetailLaporan)
                                        ]
                                  : (controller.detailLaporan.value.questions!
                                          .isNotEmpty)
                                      ? controller
                                          .detailLaporan.value.questions!
                                          .map((element) =>
                                              buildCardBalasanQuestion(element))
                                          .toList()
                                      : [
                                          Text("Belum ada balasan",
                                              style: textGreyDetailLaporan)
                                        ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                  (controller.detailLaporan.value.userId !=
                          AuthController.userId)
                      ? const SizedBox(height: 60)
                      : const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: (controller.detailLaporan.value.userId !=
              AuthController.userId)
          ? BottomSheet(
              elevation: 75,
              backgroundColor: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              builder: (context) => GestureDetector(
                onTap: () {
                  if (controller.detailLaporan.value.typePost! == "Found") {
                    openDialogMenjawab();
                  } else {
                    openDialogAjukanPertanyaan();
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      (controller.detailLaporan.value.typePost! == "Found")
                          ? "Saya Pemiliknya"
                          : "Saya Menemukan",
                      style: textWhiteMedium,
                    ),
                  ),
                ),
              ),
              onClosing: () {},
            )
          : const SizedBox(),
    );
  }

  Widget buildCardBalasanAnswer(Answers answers) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
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
                width: 50,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/surtr.jpg"),
                ),
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
                      answers.answer!,
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

  Widget buildCardBalasanQuestion(Questions questions) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
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
                width: 50,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/surtr.jpg"),
                ),
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
                      questions.question!,
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
    final _formKey = GlobalKey<FormState>();

    Get.defaultDialog(
      title: "Pertanyaan penemu",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Form(
        key: _formKey,
        child: Column(
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
                controller: controller.balasanController,
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
                if (_formKey.currentState!.validate()) {
                  controller.kirimPertanyaan();
                }
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
      ),
    );
  }

  Future openDialogMenjawab() async {
    final _formKey = GlobalKey<FormState>();

    Get.defaultDialog(
      title: "Pertanyaan penemu",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Form(
        key: _formKey,
        child: Column(
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
                controller: controller.balasanController,
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
                validator: RequiredValidator(errorText: "Jawaban harus diisi!"),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  print("Kirim");
                }
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
      ),
    );
  }

  Future openDialogHapus() async {
    Get.defaultDialog(
      title: "Yakin ingin menghapus laporan?",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Laporan yang dihapus tidak dapat dikembalikan lagi.",
            textAlign: TextAlign.center,
            style: textBlackSmallNormal,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              controller.deleteLaporan();
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  "Hapus",
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
