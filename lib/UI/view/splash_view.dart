import 'package:billify/UI/controller/splash_controller.dart';
import 'package:billify/Util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) => const Scaffold(
backgroundColor: bgColor,
        body: Center(
            child: Text("Billing",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600,color: white))),
      ),
    );
  }
}
