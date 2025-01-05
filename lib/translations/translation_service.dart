import 'package:get/get.dart';
import 'languages/en.dart';
import 'languages/hi.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'hi': hi,
      };
}

class LocaleString {
  static const String english = 'en';
  static const String hindi = 'hi';
}
