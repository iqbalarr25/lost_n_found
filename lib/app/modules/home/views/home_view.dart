import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  HomeController get controller => super.controller;

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
                        child: ListView.builder(
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) => cardLaporan(i),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Laporan yang anda ikuti",
                  style: textRedBig,
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, i) => cardLaporanIkuti(i),
              childCount: 10),
        ),
      ],
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
