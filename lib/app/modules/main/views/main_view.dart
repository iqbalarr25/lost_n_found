import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/modules/home/views/home_view.dart';
import 'package:lost_n_found/app/modules/news/views/news_view.dart';
import 'package:lost_n_found/app/modules/profile/views/profile_view.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
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
        onTap: () {
          Get.toNamed(Routes.POST);
        },
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
}
