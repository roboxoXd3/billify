import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../storage_/StorageUtil.dart';

class LanguageController extends GetxController {
  static const String LANGUAGE_KEY = 'selected_language';

  final _currentLanguage = 'en'.obs;
  String get currentLanguage => _currentLanguage.value;

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  Future<void> loadSavedLanguage() async {
    final savedLang = StorageUtil.getString(LANGUAGE_KEY);
    if (savedLang.isNotEmpty) {
      changeLanguage(savedLang);
    }
  }

  void changeLanguage(String languageCode) {
    Get.updateLocale(Locale(languageCode));
    _currentLanguage.value = languageCode;
    StorageUtil.putString(LANGUAGE_KEY, languageCode);
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      default:
        return 'English';
    }
  }
}
