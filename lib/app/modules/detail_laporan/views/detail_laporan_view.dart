import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_laporan_controller.dart';

class DetailLaporanView extends GetView<DetailLaporanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DetailLaporanView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DetailLaporanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
