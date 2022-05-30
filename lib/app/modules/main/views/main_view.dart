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
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        floatingActionButton: (controller.selectedIndex.value == 1)
            ? GestureDetector(
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
              )
            : SizedBox(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          height: 65,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: ((value) => controller.selectedIndex.value = value),
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: primaryColor,
            unselectedIconTheme: const IconThemeData(size: 25),
            selectedIconTheme: const IconThemeData(size: 30),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                ),
                label: "News",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.perm_identity,
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
