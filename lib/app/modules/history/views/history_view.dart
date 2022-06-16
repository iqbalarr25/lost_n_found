import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';
import 'package:lost_n_found/app/data/models/questions_model.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';

import '../../../themes/theme_app.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  @override
  Widget build(BuildContext context) {
    return buildHistoryPageDevelopment(context);
  }

  Widget buildHistoryPageDevelopment(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  title: Text(
                    "History",
                    style: textAppBar,
                  ),
                  floating: true,
                  pinned: true,
                  snap: false,
                  bottom: PreferredSize(
                    child: SizedBox(
                      height: 50,
                      child: Obx(
                        () => ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, top: 13, bottom: 13),
                              child: GestureDetector(
                                onTap: () {
                                  controller.filterBehaviour(
                                      laporanSemuaSelected: !controller
                                          .laporanSemuaSelected.value);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: (controller
                                                .laporanSemuaSelected.value)
                                            ? Colors.red
                                            : Colors.transparent),
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      "Semua",
                                      style: (controller
                                              .laporanSemuaSelected.value)
                                          ? textRedSmallNormal
                                          : textBlackSmallNormal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, top: 13, bottom: 13),
                              child: GestureDetector(
                                onTap: () {
                                  controller.filterBehaviour(
                                      laporanAndaSelected: !controller
                                          .laporanAndaSelected.value);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: (controller
                                                .laporanAndaSelected.value)
                                            ? Colors.red
                                            : Colors.transparent),
                                  ),
                                  child: Text(
                                    "Laporan Anda",
                                    style:
                                        (controller.laporanAndaSelected.value)
                                            ? textRedSmallNormal
                                            : textBlackSmallNormal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, top: 13, bottom: 13),
                              child: GestureDetector(
                                onTap: () {
                                  controller.filterBehaviour(
                                      laporanDiikutiSelected: !controller
                                          .laporanDiikutiSelected.value);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: (controller
                                                .laporanDiikutiSelected.value)
                                            ? Colors.red
                                            : Colors.transparent),
                                  ),
                                  child: Text(
                                    "Laporan Diikuti",
                                    style: (controller
                                            .laporanDiikutiSelected.value)
                                        ? textRedSmallNormal
                                        : textBlackSmallNormal,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    preferredSize: const Size.fromHeight(50),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              buildSearchTextField(),
              Expanded(
                child: Obx(
                  () => MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: (!controller.isLoading.value)
                        ? FutureBuilder(
                            future: controller.tampilPostLaporanHistoryFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (controller.historyAllPost.isNotEmpty) {
                                  return ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: controller.historyAllPost.length,
                                    itemBuilder: (context, index) =>
                                        buildCardHistory(
                                            controller.historyAllPost[index],
                                            context),
                                  );
                                } else {
                                  return Center(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        "Belum ada history",
                                        style: textRedMini,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHistoryPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "History",
          style: textAppBar,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await (controller.tampilPostLaporanHistoryFuture =
              controller.tampilPostLaporanHistory());
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              buildSearchTextField(),
              Expanded(
                child: Obx(
                  () => MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: (!controller.isLoading.value)
                        ? FutureBuilder(
                            future: controller.tampilPostLaporanHistoryFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (controller.historyAllPost.isNotEmpty) {
                                  return ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: controller.historyAllPost.length,
                                    itemBuilder: (context, index) =>
                                        buildCardHistory(
                                            controller.historyAllPost[index],
                                            context),
                                  );
                                } else {
                                  return Center(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        "Belum ada history",
                                        style: textRedMini,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: CupertinoSearchTextField(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: searchColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        prefixInsets: EdgeInsets.only(left: 20, right: 10),
        suffixIcon: const Icon(Icons.close),
        suffixMode: OverlayVisibilityMode.editing,
        suffixInsets: EdgeInsets.only(right: 10),
        itemColor: Colors.black,
      ),
    );
  }

  Widget buildCardHistory(MyPost post, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          if (post.typePost == "Lost") {
            if (post.questions![post.questions!.length - 1].answers![0]
                    .statusAnswer ==
                "Finished") {
              if (controller.box.read("dataUser")["userId"] == post.userId) {
                print("user");
                openDialogJawaban(
                    post: post,
                    questions: post.questions![post.questions!.length - 1],
                    context: context);
              } else {
                controller.openDialogKontak(post, context);
              }
            } else {
              Get.toNamed(Routes.DETAIL_LAPORAN, arguments: post);
            }
          } else {}
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: 360,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(width: 10)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                post.title!.capitalizeFirst!,
                                style: textTitleCard,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              post.date!,
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (post.typePost == "Lost") ...[
                        Text(
                          "Status: " +
                              post.questions![post.questions!.length - 1]
                                  .statusQuestion!,
                          style: (post.questions![post.questions!.length - 1]
                                      .statusQuestion! ==
                                  "Finished")
                              ? textGreenDarkCard
                              : textGreyCard,
                        ),
                      ] else ...[
                        Text(
                          "Status: " +
                              post.questions![0].answers![0].statusAnswer!,
                          style:
                              (post.questions![0].answers![0].statusAnswer! ==
                                      "Finished")
                                  ? textGreenDarkCard
                                  : textGreyCard,
                        ),
                      ],
                      const SizedBox(width: 15),
                      if (post.typePost == "Lost") ...[
                        if (controller.box.read("dataUser")["userId"] ==
                            post.userId) ...[
                          Text(
                            "Detail",
                            style: textRedMini,
                          ),
                        ] else ...[
                          Text(
                            (post.questions![post.questions!.length - 1]
                                        .statusQuestion! ==
                                    "Finished")
                                ? "Cek kontak"
                                : "Detail",
                            style: textRedMini,
                          ),
                        ],
                      ] else ...[
                        Text(
                          (post.questions![0].answers![0].statusAnswer ==
                                  "Finished")
                              ? "Cek kontak"
                              : "Detail",
                          style: textRedMini,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
            questions.question!,
            style: textBlackSmallNormal,
          ),
          const SizedBox(height: 15),
          Text(
            "Iqbal Arrafi",
            style: textBlackSmall,
          ),
          const SizedBox(height: 10),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: const AssetImage("assets/images/avatar.jpg"),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: (post.user!.imgUrl != null)
                  ? NetworkImage(post.user!.imgUrl!)
                  : const AssetImage("assets/images/avatar.jpg")
                      as ImageProvider,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            questions.answers![0].answer!,
            style: textGreyMediumNormal,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
