import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/modules/home/views/home_view.dart';
import 'package:lost_n_found/app/modules/news/views/news_view.dart';
import 'package:lost_n_found/app/modules/profile/views/profile_view.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  final pages = [
    HomeView(),
    NewsView(),
    ProfileView(),
  ];

  @override
  MainController get controller => super.controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.selectedIndex.value]),
      floatingActionButton: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 5,
            left: 7,
            right: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: primaryColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle,
                color: whiteColor,
                size: 32,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "Post",
                style: textWhiteMedium,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4), // Shadow position
            ),
          ],
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                controller.selectedIndex.value = 0;
              },
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Icon(
                        Icons.home,
                        color: (controller.selectedIndex.value == 0)
                            ? primaryColor
                            : greyColor,
                        size: 35,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "Home",
                        style: (controller.selectedIndex.value == 0)
                            ? textBottomNavBarActive
                            : textBottomNavBar,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.selectedIndex.value = 1;
              },
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Icon(
                        Icons.map,
                        color: (controller.selectedIndex.value == 1)
                            ? primaryColor
                            : greyColor,
                        size: 35,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "News",
                        style: (controller.selectedIndex.value == 1)
                            ? textBottomNavBarActive
                            : textBottomNavBar,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.selectedIndex.value = 2;
              },
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Icon(
                        Icons.perm_identity,
                        color: (controller.selectedIndex.value == 2)
                            ? primaryColor
                            : greyColor,
                        size: 35,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "Profile",
                        style: (controller.selectedIndex.value == 2)
                            ? textBottomNavBarActive
                            : textBottomNavBar,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardLaporan(int i) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: (i == 4) ? 20 : 0),
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
                  borderRadius: BorderRadius.circular(10),
                  color: greyColor,
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
    );
  }

  Widget cardLaporanIkuti(int i) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: (i == 0) ? 0 : 5),
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
                      color: greyColor,
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
              Container(
                margin: const EdgeInsets.only(bottom: 8, right: 7),
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
