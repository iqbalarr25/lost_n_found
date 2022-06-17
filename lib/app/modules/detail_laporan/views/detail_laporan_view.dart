import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/data/models/answers_model.dart';
import 'package:lost_n_found/app/data/models/questions_model.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';
import '../controllers/detail_laporan_controller.dart';

class DetailLaporanView extends GetView<DetailLaporanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildDetailLaporan(context));
  }

  Widget buildDetailLaporan(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail laporan',
          style: textAppBar,
        ),
        actions: [
          if (controller.post.value.userId ==
              controller.box.read("dataUser")["userId"]) ...[
            IconButton(
              onPressed: () {
                if (controller.detailLaporan.value.id != null) {
                  Get.toNamed(Routes.POST,
                      arguments: controller.detailLaporan.value);
                }
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
      body: Obx(
        () => Stack(
          children: [
            Obx(
              () => SingleChildScrollView(
                physics: (controller.isZoomImage.value)
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.isZoomImage.value =
                                !controller.isZoomImage.value;
                          },
                          child: CarouselSlider.builder(
                            itemCount: controller.post.value.imgUrl!.length,
                            itemBuilder: (context, itemIndex, pageViewIndex) =>
                                Hero(
                              tag: controller.post.value.imgUrl![itemIndex],
                              child: Image.network(
                                controller.post.value.imgUrl![itemIndex],
                              ),
                            ),
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              autoPlay:
                                  (controller.post.value.imgUrl!.length != 1)
                                      ? true
                                      : false,
                              height: 230,
                              onPageChanged: (index, reason) {
                                controller.currentPos.value = index;
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: controller.post.value.imgUrl!.map((url) {
                            int index =
                                controller.post.value.imgUrl!.indexOf(url);
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.post.value.title!.capitalizeFirst!,
                              style: textBlackBig,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                controller.post.value.typePost!,
                                style: textWhiteMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: controller.tampilDetailLaporanFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  right: 20, left: 20, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textTitleBody(
                                    title: "Deskripsi",
                                    body: Text(
                                      controller.detailLaporan.value
                                          .description!.capitalizeFirst!,
                                      style: textGreyDetailLaporan,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  textTitleBody(
                                    title: "Kronologi",
                                    body: Text(
                                      controller.detailLaporan.value.chronology!
                                          .capitalizeFirst!,
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
                                  if (controller.detailLaporan.value.typePost ==
                                      "Found")
                                    textTitleBody(
                                      title: "Pertanyaan",
                                      body: Text(
                                        controller.detailLaporan.value
                                            .questions![0].question!,
                                        style: textGreyDetailLaporan,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  if (controller.detailLaporan.value.userId ==
                                      controller.box
                                          .read("dataUser")["userId"]) ...[
                                    Obx(
                                      () => textTitleBody(
                                        title: "Balasan",
                                        body: (!controller.isLoading.value)
                                            ? Column(
                                                children: (controller
                                                            .detailLaporan
                                                            .value
                                                            .typePost ==
                                                        "Found")
                                                    ? (controller
                                                            .detailLaporan
                                                            .value
                                                            .questions![0]
                                                            .answers!
                                                            .isNotEmpty)
                                                        ? controller
                                                            .detailLaporan
                                                            .value
                                                            .questions![0]
                                                            .answers!
                                                            .map((element) =>
                                                                buildCardBalasanAnswer(
                                                                    element))
                                                            .toList()
                                                        : [
                                                            Text(
                                                                "Belum ada balasan",
                                                                style:
                                                                    textGreyDetailLaporan)
                                                          ]
                                                    : (controller
                                                            .detailLaporan
                                                            .value
                                                            .questions!
                                                            .isNotEmpty)
                                                        ? controller
                                                            .detailLaporan
                                                            .value
                                                            .questions!
                                                            .map((element) =>
                                                                buildCardBalasanQuestion(
                                                                    element))
                                                            .toList()
                                                        : [
                                                            Text(
                                                                "Belum ada balasan",
                                                                style:
                                                                    textGreyDetailLaporan)
                                                          ],
                                              )
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                      ),
                                    ),
                                  ],
                                  (controller.detailLaporan.value.userId !=
                                          controller.box
                                              .read("dataUser")["userId"])
                                      ? const SizedBox(height: 60)
                                      : const SizedBox(height: 10),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
            if (controller.isZoomImage.value) ...[
              GestureDetector(
                onTap: () => controller.isZoomImage.value =
                    !controller.isZoomImage.value,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: blackColor.withOpacity(0.6),
                ),
              ),
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.post.value.imgUrl!.length,
                    itemBuilder: (context, index) => InteractiveViewer(
                      panEnabled: true,
                      alignPanAxis: true,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Image.network(
                          controller.post.value.imgUrl![index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
      bottomSheet: (controller.post.value.userId !=
              controller.box.read("dataUser")["userId"])
          ? BottomSheet(
              enableDrag: false,
              elevation: 75,
              backgroundColor: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              builder: (context) => GestureDetector(
                onTap: () {
                  if (controller.detailLaporan.value.activeStatus!) {
                    if (controller.detailLaporan.value.typePost! == "Found") {
                      openDialogMenjawab();
                    } else {
                      if (controller.detailLaporan.value.questions != null) {
                        if (controller.detailLaporan.value.questions![0]
                                .statusQuestion ==
                            "Answered") {
                          Get.offAllNamed(Routes.MAIN, arguments: 0);
                        } else {
                          openDialogAjukanPertanyaan();
                        }
                      } else {
                        openDialogAjukanPertanyaan();
                      }
                    }
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    color: (controller.detailLaporan.value.activeStatus!)
                        ? primaryColor
                        : greenColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        controller.textBottomSheet.value,
                        style: textWhiteMedium,
                      ),
                    ),
                  ),
                ),
              ),
              onClosing: () {},
            )
          : const SizedBox(),
    );
  }

  Widget buildCardBalasanAnswer(MyAnswers answers) {
    return GestureDetector(
      onTap: () => openDialogKonfirmasiBalasan(answers),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Material(
          borderRadius: BorderRadius.circular(50),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
            height: 55,
            decoration: BoxDecoration(
              color: (answers.statusAnswer == "Accepted")
                  ? greenColor
                  : primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: CircleAvatar(
                    backgroundColor: primaryColor,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: (answers.user!.imgUrl != null)
                          ? NetworkImage(answers.user!.imgUrl!)
                          : const AssetImage("assets/images/avatar.jpg")
                              as ImageProvider,
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          answers.user!.name!.capitalizeFirst!,
                          style: (answers.statusAnswer == "Accepted")
                              ? textBlackSmallNormal
                              : textWhiteSmallNormal,
                        ),
                      ),
                      Text(
                        answers.answer!.capitalizeFirst!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: (answers.statusAnswer == "Accepted")
                            ? textBlackSmallBalasan
                            : textWhiteSmallBalasan,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
      ),
    );
  }

  Widget buildCardBalasanQuestion(MyQuestions questions) {
    return GestureDetector(
      onTap: () => openDialogMenjawabBalasan(questions),
      child: Container(
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
                SizedBox(
                  width: 50,
                  child: CircleAvatar(
                    backgroundColor: primaryColor,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: (questions.user!.imgUrl != null)
                          ? NetworkImage(questions.user!.imgUrl!)
                          : const AssetImage("assets/images/avatar.jpg")
                              as ImageProvider,
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          questions.user!.name!.capitalizeFirst!,
                          style: textWhiteSmallNormal,
                        ),
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
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
            buildTextFormField(hint: "Masukkan pertanyaan"),
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
              controller.detailLaporan.value.questions![0].question!,
              style: textBlackSmallNormal,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            buildTextFormField(hint: "Masukkan jawaban"),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  controller.kirimJawaban();
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

  Future openDialogMenjawabBalasan(MyQuestions questions) async {
    final _formKey = GlobalKey<FormState>();

    Get.defaultDialog(
      title: "Pertanyaan",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 5),
            Text(
              questions.question!,
              style: textBlackSmallNormal,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                questions.user!.name!.capitalizeFirst!,
                style: textBlackSmall,
              ),
            ),
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 35,
              backgroundColor: primaryColor,
              backgroundImage: const AssetImage("assets/images/avatar.jpg"),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.transparent,
                backgroundImage: (questions.user!.imgUrl != null)
                    ? NetworkImage(questions.user!.imgUrl!)
                    : const AssetImage("assets/images/avatar.jpg")
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 10),
            buildTextFormField(hint: "Masukkan jawaban"),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  controller.kirimJawabanBalasan(questions);
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

  Future openDialogKonfirmasiBalasan(MyAnswers answers) async {
    final _formKey = GlobalKey<FormState>();

    Get.defaultDialog(
      title: "Jawaban",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text(
              answers.answer!.capitalizeFirst!,
              style: textBlackSmallNormal,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                answers.user!.name!.capitalizeFirst!,
                style: textBlackSmall,
              ),
            ),
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 35,
              backgroundColor: primaryColor,
              backgroundImage: const AssetImage("assets/images/avatar.jpg"),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.transparent,
                backgroundImage: (answers.user!.imgUrl != null)
                    ? NetworkImage(answers.user!.imgUrl!)
                    : const AssetImage("assets/images/avatar.jpg")
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 10),
            (answers.statusAnswer == "Accepted")
                ? const SizedBox()
                : Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () => controller.interaksiJawabanBalasan(
                              answers, false),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                "Tolak",
                                style: textWhiteMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () =>
                              controller.interaksiJawabanBalasan(answers, true),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                "Terima",
                                style: textWhiteMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget buildTextFormField({required String hint, required}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 130),
      child: TextFormField(
        controller: controller.balasanController,
        textAlignVertical: TextAlignVertical.top,
        maxLines: null,
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
        validator: RequiredValidator(errorText: "Jawaban harus diisi!"),
      ),
    );
  }
}
