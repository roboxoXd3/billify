import 'package:billify/navigation/app_pages.dart';
import 'package:billify/storage_/StorageUtil.dart';
import 'package:billify/storage_/storage_const.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      if (StorageUtil.getBoolean(isUserCreated)) {
        Get.offAllNamed(Routes.homePage);
      } else {
        Get.offAllNamed(Routes.businessCreate);
      }
    });

    super.onInit();
  }
}
