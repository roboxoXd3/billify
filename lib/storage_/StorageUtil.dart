import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil? _storageUtil;
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    if (_storageUtil == null) {
      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
  }

  static Future<StorageUtil?> getInstance() async {
    if (_storageUtil == null) {
      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  StorageUtil._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // get string
  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(key) ?? defValue;
  }

  // put string
  static Future<bool>? putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(key, value);
  }

  // get int
  static int getInt(String key, {int defValue = 0}) {
    if (_preferences == null) return defValue;
    return _preferences!.getInt(key) ?? defValue;
  }

  // put int
  static Future<bool>? putInt(String key, int value) {
    if (_preferences == null) return null;
    return _preferences!.setInt(key, value);
  }

  // get object
  static String getObject(String key) {
    if (_preferences == null) return "";
    return _preferences!.getString(key) ?? "";
  }

  // put object
  static Future<bool>? putObject(String key, data) {
    if (_preferences == null) return null;
    if (data == null) {
      return _preferences!.setString(key, "");
    }
    return _preferences!.setString(key, jsonEncode(data));
  }

  // get string
  static bool getBoolean(String key, {bool defValue = false}) {
    if (_preferences == null) return defValue;
    return _preferences!.getBool(key) ?? defValue;
  }

  // put bool
  static Future<bool>? putBoolean(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences!.setBool(key, value);
  }

  // put string
  static Future<bool>? putStringList(String key, List<String> value) {
    if (_preferences == null) return null;
    return _preferences!.setStringList(key, value);
  }

  // get string
  static List<String>? getStringList(String key) {
    if (_preferences == null) return null;
    return _preferences!.getStringList(key);
  }

  static Future clear() async {
    _preferences = await SharedPreferences.getInstance();
    _preferences?.clear();
  }
}
