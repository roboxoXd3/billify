import 'dart:convert';

import 'package:billify/model/profile_response.dart';
import 'package:billify/storage_/StorageUtil.dart';
import 'package:billify/storage_/storage_const.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  BusinessDetails profileData = BusinessDetails();
  @override
  void onInit() {
    var response = StorageUtil.getObject(userData);
     var jsonResponse = jsonDecode(response);
    profileData = BusinessDetails.fromJson(jsonResponse);
    super.onInit();
  }
}
