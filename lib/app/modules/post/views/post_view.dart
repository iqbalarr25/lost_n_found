import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/post_controller.dart';

class PostView extends GetView<PostController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PostView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PostView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
