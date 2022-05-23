import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          title: Text(
            "Lost & Found",
            style: textAppBar,
          ),
          backgroundColor: primaryColor,
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Container(
                color: primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child:
                          Text("Daftar laporan anda", style: textWhiteMedium),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: primaryColor,
                      child: SizedBox(
                        height: 150,
                        child: FutureBuilder(
                          future: controller.tampilPostLaporanAnda(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: whiteColor,
                                ),
                              );
                            } else {
                              if (controller.laporanAnda.length == 0) {
                                return Center(
                                  child: Text(
                                    "Belum mempunyai laporan :(",
                                    style: textWhiteSmallNormal,
                                  ),
                                );
                              }
                            }
                            return Obx(
                              () => ListView.builder(
                                itemCount: controller.laporanAnda.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) => cardLaporan(
                                    post: controller.laporanAnda[i], index: i),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Laporan yang anda ikuti",
                  style: textRedBig,
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: controller.tampilPostFollowing(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, i) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                    childCount: 1),
              );
            } else {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, i) => cardLaporanIkuti(
                          index: i,
                        ),
                    childCount: controller.laporanDiikuti.length),
              );
            }
          },
        ),
      ],
    );
  }

  Widget cardLaporan({required Post post, required int index}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.DETAIL_LAPORAN, arguments: post);
      },
      child: Container(
        margin: EdgeInsets.only(
            left: 16,
            right: (index == controller.laporanAnda.length - 1 &&
                    controller.laporanAnda.length != 1)
                ? 20
                : 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: 330,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: whiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        post.imgUrl![0],
                      ),
                    ),
                  ),
                  width: 130,
                  height: 130,
                ),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title.toString().capitalizeFirst!,
                            style: textTitleCard,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            post.date.toString(),
                            style: textGreyCard,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: primaryColor,
                            ),
                            child: Text(
                              post.typePost!,
                              style: textWhiteMedium,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Penemu: 0",
                        style: textGreyCard,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 7, right: 7),
              child: Text(
                "Detail",
                style: textRedMini,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardLaporanIkuti({required int index}) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 10, vertical: (index == 0) ? 0 : 5),
      width: 330,
      child: Card(
        elevation: 1,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: whiteColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/images/surtr.jpg",
                        ),
                      ),
                    ),
                    width: 130,
                    height: 130,
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 110,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Laptop Gaming",
                              style: textTitleCard,
                            ),
                            const SizedBox(height: 1),
                            Text(
                              "11 November 2022",
                              style: textGreyCard,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: primaryColor,
                              ),
                              child: Text(
                                "Lost",
                                style: textWhiteMedium,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Status: Menunggu",
                          style: textGreyCard,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  openDialogJawaban();
                },
                child: Container(
                  color: whiteColor,
                  padding: const EdgeInsets.only(bottom: 8, right: 7),
                  child: Text(
                    "Detail",
                    style: textRedMini,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future openDialogJawaban() async {
    Get.defaultDialog(
      title: "Pertanyaan anda",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Column(
        children: [
          Text(
            "1. Apa background dari laptop",
            style: textBlackSmallNormal,
          ),
          const SizedBox(height: 15),
          Text(
            "Iqbal Arrafi",
            style: textBlackSmall,
          ),
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/images/surtr.jpg"),
          ),
          Text(
            "waifu saya, fu hua",
            style: textGreyCard,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    print("Tolak");
                  },
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
                  onTap: () {
                    print("Terima");
                  },
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
        ],
      ),
    );
  }

  Future openDialogKontak() async {
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
            "Whatsapp",
            style: textBlackMedium,
          ),
          Text(
            "082113313733",
            style: textGreyMediumNormal,
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              print("Salin");
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
    );
  }
}
