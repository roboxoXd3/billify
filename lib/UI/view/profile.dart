import 'package:billify/UI/controller/profile_controller.dart';
import 'package:billify/Util/app_colors.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: bgColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon:const  Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white)),
          ),
          body: Column(
            children: [
              Text(controller.profileData.businessName!.validate()),
              Text(controller.profileData.userName!.validate()),
              Text(controller.profileData.phoneNumber.validate()),
            ],
          ),
        );
      },
    );
  }
}
