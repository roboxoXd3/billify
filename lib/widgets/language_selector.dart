import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../translations/language_controller.dart';

class LanguageSelector extends GetView<LanguageController> {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language, color: Colors.white),
      onSelected: controller.changeLanguage,
      itemBuilder: (context) => [
        buildLanguageItem('en', 'English'),
        buildLanguageItem('hi', 'हिंदी'),
      ],
    );
  }

  PopupMenuItem<String> buildLanguageItem(String code, String name) {
    return PopupMenuItem<String>(
      value: code,
      child: Row(
        children: [
          Obx(() => Radio<String>(
                value: code,
                groupValue: controller.currentLanguage,
                onChanged: (value) => controller.changeLanguage(value!),
              )),
          Text(name),
        ],
      ),
    );
  }
}
