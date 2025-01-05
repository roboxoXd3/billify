import 'package:billify/UI/binding/splash_binding.dart';
import 'package:billify/navigation/app_pages.dart';
import 'package:billify/storage_/StorageUtil.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get.dart';
import 'package:billify/translations/language_controller.dart';
import 'package:billify/translations/translation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.init();

  Get.put(LanguageController());

  runApp(GetMaterialApp(
    translations: TranslationService(),
    locale: const Locale('en'), // Default locale
    fallbackLocale: const Locale('en'),
    navigatorKey: navigatorKey,
    color: whiteColor,
    getPages: AppPages.pages,
    initialRoute: Routes.landingPage,
    initialBinding: SplashBinding(),
    debugShowCheckedModeBanner: false,
  ));
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
            initialRoute: Routes.landingPage,
            initialBinding: SplashBinding(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
