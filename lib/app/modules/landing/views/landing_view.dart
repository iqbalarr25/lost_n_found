import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/landing_controller.dart';

class LandingView extends GetView<LandingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LandingView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LandingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
