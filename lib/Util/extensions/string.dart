import 'dart:async';

import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/services.dart';

extension StringExt on String {
  Future<String?> loadFile() async {
    return tryCatchAsync(() async {
      return await rootBundle.loadString(this);
    });
  }

  String mask({
    int prefixLength = 2,
    int suffixLength = 3,
    int maskLength = 5,
    String maskValue = '*',
    bool ignore = false,
  }) {
    if (length <= prefixLength + suffixLength) {
      return ignore ? this : maskValue * length;
    }
    if (maskValue.isEmpty) return this;
    int maskedPortionLength = length - prefixLength - suffixLength;
    String mask = maskValue *
        (maskedPortionLength > maskLength ? maskLength : maskedPortionLength);
    print(
        'prefixLength: $prefixLength, suffixLength: $suffixLength, maskLength: $maskLength, maskValue: $maskValue, ignore: $ignore maskedPortionLength: $maskedPortionLength, mask: $mask');
    return substring(0, prefixLength) + mask + substring(length - suffixLength);
  }

  String getInitials() {
    List<String> words = trim().split(RegExp(r'\s+'));

    if (words.length > 1) {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    } else if (words.length == 1) {
      String singleWord = words[0];
      if (singleWord.length == 1) {
        return singleWord.toUpperCase();
      } else {
        return singleWord.substring(0, 2).toUpperCase();
      }
    }

    return ""; // Return empty if no valid name
  }
}
