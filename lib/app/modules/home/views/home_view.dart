import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';
import 'package:lost_n_found/app/data/models/questions_model.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.isLoading.value = true;
        await (controller.tampilPostLaporanAndaFuture =
            controller.tampilPostLaporanAnda());
        await (controller.tampilPostFollowingFuture =
            controller.tampilPostFollowing());
        controller.isLoading.value = false;
      },
      child: Obx(
        () => CustomScrollView(
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
                          child: Text("Daftar laporan anda",
                              style: textWhiteMedium),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          color: primaryColor,
                          child: SizedBox(
                            height: 150,
                            child: (controller.isLoading.value)
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: whiteColor,
                                    ),
                                  )
                                : FutureBuilder<RxList<MyPost>>(
                                    future:
                                        controller.tampilPostLaporanAndaFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: whiteColor,
                                          ),
                                        );
                                      } else {
                                        if (controller.laporanAnda.isEmpty) {
                                          return Center(
                                            child: Text(
                                              "Belum mempunyai laporan :(",
                                              style: textWhiteSmallNormal,
                                            ),
                                          );
                                        } else {
                                          return ListView.builder(
                                            itemCount:
                                                controller.laporanAnda.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, i) =>
                                                cardLaporan(
                                                    post: controller
                                                        .laporanAnda[i],
                                                    index: i),
                                          );
                                        }
                                      }
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
                  if (controller.isLoading.value) ...[
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.10),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ] else ...[
                    FutureBuilder<RxList<MyPost>>(
                      future: controller.tampilPostFollowingFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.10),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          if (controller.laporanDiikuti.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.15),
                              child: Center(
                                child: Text(
                                  "Belum ada laporan",
                                  style: textRedMini,
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              children: controller.laporanDiikuti
                                  .map(
                                    (element) => cardLaporanIkuti(
                                        post: element, context: context),
                                  )
                                  .toList(),
                            );
                          }
                        }
                      },
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardLaporan({required MyPost post, required int index}) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.DETAIL_LAPORAN, arguments: post),
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
                Hero(
                  tag: post.imgUrl![0],
                  child: Container(
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
                          SizedBox(
                            width: 130,
                            child: Text(
                              post.title!.capitalizeFirst!,
                              style: textTitleCard,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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

  Widget cardLaporanIkuti(
      {required MyPost post, required BuildContext context}) {
    return Column(
      children: (post.typePost == "Found")
          ? post.questions![0].answers!
              .map((e) => (e.statusAnswer == "Waiting" ||
                      e.statusAnswer == "Accepted")
                  ? InkWell(
                      onTap: () {
                        if (post.questions![0].statusQuestion! == "Waiting") {
                          Get.toNamed(Routes.DETAIL_LAPORAN, arguments: post);
                        } else {
                          controller.followingFoundFinish(
                              post, post.questions![0], context);
                        }
                      },
                      child: SizedBox(
                        width: 330,
                        child: Card(
                          elevation: 1,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
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
                                    Hero(
                                      tag: post.imgUrl![0],
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: 110,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 117,
                                                child: Text(
                                                  post.title!.capitalizeFirst!,
                                                  style: textTitleCard,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(height: 1),
                                              Text(
                                                post.date!,
                                                style: textGreyCard,
                                              ),
                                              const SizedBox(height: 5),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
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
                                            "Status: " + e.statusAnswer!,
                                            style:
                                                (e.statusAnswer == "Accepted")
                                                    ? textGreenDarkCard
                                                    : textGreyCard,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: whiteColor,
                                  padding: const EdgeInsets.only(
                                      bottom: 10, right: 7),
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
                    )
                  : const SizedBox())
              .toList()
              .obs
          : post.questions!
              .map(
                (e) => (e.statusQuestion == "Waiting" ||
                        e.statusQuestion == "Answered")
                    ? InkWell(
                        onTap: () {
                          if (post.questions![0].statusQuestion! ==
                              "Answered") {
                            openDialogJawaban(
                                post: post, questions: e, context: context);
                          } else if (post.questions![0].statusQuestion! ==
                              "Waiting") {
                            Get.toNamed(Routes.DETAIL_LAPORAN, arguments: post);
                          }
                        },
                        child: SizedBox(
                          width: 330,
                          child: Card(
                            elevation: 1,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: whiteColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Hero(
                                        tag: post.imgUrl![0],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        height: 110,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post.title!,
                                                  style: textTitleCard,
                                                ),
                                                const SizedBox(height: 1),
                                                Text(
                                                  post.date!,
                                                  style: textGreyCard,
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
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
                                              "Status: " + e.statusQuestion!,
                                              style: (e.statusQuestion ==
                                                      "Answered")
                                                  ? textGreenDarkCard
                                                  : textGreyCard,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    color: whiteColor,
                                    padding: const EdgeInsets.only(
                                        bottom: 10, right: 7),
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
                      )
                    : const SizedBox(),
              )
              .toList()
              .obs,
    );
  }

  Future openDialogJawaban(
      {required MyPost post,
      required MyQuestions questions,
      required BuildContext context}) async {
    Get.defaultDialog(
      title: "Pertanyaan anda",
      titleStyle: textBlackBig,
      titlePadding: const EdgeInsets.only(top: 25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            post.questions![0].question!,
            style: textBlackSmallNormal,
          ),
          const SizedBox(height: 15),
          Text(
            "Iqbal Arrafi",
            style: textBlackSmall,
          ),
          const SizedBox(height: 10),
          CircleAvatar(
            backgroundColor: primaryColor,
            radius: 30,
            backgroundImage: const AssetImage("assets/images/avatar.jpg"),
          ),
          const SizedBox(height: 10),
          Text(
            questions.answers![0].answer!,
            style: textGreyCard,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    await (controller.interaksiPostFollowing(
                        post, questions, false, context));
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
                    controller.interaksiPostFollowing(
                        post, questions, true, context);
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
}
