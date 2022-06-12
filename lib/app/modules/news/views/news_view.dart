import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/data/models/post_model.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';

import '../../../themes/theme_app.dart';
import '../controllers/news_controller.dart';

class NewsView extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                title: Text(
                  "Lost & Found",
                  style: textAppBar,
                ),
                floating: true,
                pinned: true,
                snap: false,
                bottom: TabBar(
                  controller: controller.tabController,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text(
                        "Lost",
                        style: textWhiteMedium,
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Found",
                        style: textWhiteMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: controller.tabController,
        children: [
          buildLostTab(context),
          buildFoundTab(context),
        ],
      ),
    );
  }

  Widget buildLostTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.refreshTab(0);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            buildSearchTextField(searchText: controller.searchTextLost),
            Expanded(
              child: Obx(
                () => MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: (!controller.isLoadingLost.value)
                      ? FutureBuilder<RxList<MyPost>>(
                          future: controller.tampilPostLaporanNewsLost,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (controller.laporanNewsLost.isNotEmpty) {
                                return Obx(
                                  () => ListView.builder(
                                    controller: controller.scrollControllerLost,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: (controller
                                                .searchTextLost.text.isEmpty &&
                                            controller.laporanNewsLost.length %
                                                    5 ==
                                                0)
                                        ? controller.laporanNewsLost.length + 1
                                        : controller.laporanNewsLost.length,
                                    itemBuilder: (context, index) {
                                      if (index <
                                          controller.laporanNewsLost.length) {
                                        return cardLaporan(
                                            controller.laporanNewsLost[index]);
                                      } else {
                                        return (!(controller.offsetLost >
                                                controller
                                                    .laporanNewsLost.length))
                                            ? const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 32),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 32),
                                                child: Center(
                                                  child: Text(
                                                    "Tidak ada laporan lagi",
                                                    style: textRedMini,
                                                  ),
                                                ),
                                              );
                                      }
                                    },
                                  ),
                                );
                              } else {
                                return Center(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      "Belum ada laporan kehilangan",
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
    );
  }

  Widget buildFoundTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.refreshTab(1);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            buildSearchTextField(searchText: controller.searchTextFound),
            Expanded(
              child: Obx(
                () => MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: (!controller.isLoadingFound.value)
                      ? FutureBuilder<RxList<MyPost>>(
                          future: controller.tampilPostLaporanNewsFound,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (controller.laporanNewsFound.isNotEmpty) {
                                return Obx(
                                  () => ListView.builder(
                                    controller:
                                        controller.scrollControllerFound,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: (controller
                                                .searchTextFound.text.isEmpty &&
                                            controller.laporanNewsFound.length %
                                                    5 ==
                                                0)
                                        ? controller.laporanNewsFound.length + 1
                                        : controller.laporanNewsFound.length,
                                    itemBuilder: (context, index) {
                                      if (index <
                                          controller.laporanNewsFound.length) {
                                        return cardLaporan(
                                            controller.laporanNewsFound[index]);
                                      } else {
                                        return (!(controller.offsetFound >
                                                controller
                                                    .laporanNewsFound.length))
                                            ? const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 32),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 32),
                                                child: Center(
                                                  child: Text(
                                                    "Tidak ada laporan lagi",
                                                    style: textRedMini,
                                                  ),
                                                ),
                                              );
                                      }
                                    },
                                  ),
                                );
                              } else {
                                return Center(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      "Belum ada laporan penemuan",
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
    );
  }

  Widget buildSearchTextField({required TextEditingController searchText}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: CupertinoSearchTextField(
        onSuffixTap: () {
          searchText.text = "";
          controller.refreshTab(controller.thisPage.value);
        },
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: searchColor,
        ),
        onSubmitted: (value) {
          controller.refreshTab(controller.thisPage.value);
        },
        controller: searchText,
        padding: const EdgeInsets.symmetric(vertical: 10),
        prefixInsets: const EdgeInsets.only(left: 20, right: 10),
        suffixIcon: const Icon(Icons.close),
        suffixMode: OverlayVisibilityMode.editing,
        suffixInsets: const EdgeInsets.only(right: 10),
        itemColor: Colors.black,
      ),
    );
  }

  Widget cardLaporan(MyPost post) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.DETAIL_LAPORAN, arguments: post);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}
