import 'package:billify/UI/binding/splash_binding.dart';
import 'package:billify/navigation/app_pages.dart';
import 'package:billify/storage_/StorageUtil.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await StorageUtil.getInstance();
  setOrientationPortrait();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            color: whiteColor,
            getPages: AppPages.pages,
            initialRoute: AppPages.initial,
            initialBinding: SplashBinding(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
