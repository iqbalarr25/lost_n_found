import 'package:flutter/material.dart';
import 'package:lost_n_found/app/controllers/auth_controller.dart';
import 'package:lost_n_found/app/routes/app_pages.dart';
import 'package:lost_n_found/app/themes/theme_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              color: whiteColor,
            ),
            Center(
              child: Image.asset(
                "assets/images/logo_lofo_transparent.png",
                alignment: Alignment.center,
                scale: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
