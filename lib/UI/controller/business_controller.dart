import 'package:billify/model/addLineItem.dart';
import 'package:billify/navigation/app_pages.dart';
import 'package:billify/storage_/StorageUtil.dart';
import 'package:billify/storage_/storage_const.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BusinessController extends GetxController {
  final formkey = GlobalKey<FormState>();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
   List<FormTemplateModel> templates = List.empty(growable: true);
  String? selectedTemplateName;
  String? selectedTemplateType;

@override
  void onInit () {
  addFormTemplates();
super.onInit();
}

addFormTemplates() {
  templates.add(FormTemplateModel(formName: 'Default Template', formType: "1"));
  templates.add(FormTemplateModel(formName: 'Optical Shop Template',formType: "2"));
update();
}
onSubmit() async {
  final profileData = {
    'businessName': businessNameController.text,
    'userName': userNameController.text,
    'phoneNumber': phoneNumberController.text,
    'selectedTemplate': selectedTemplateName,
    'selectedTemplateType': selectedTemplateType,
  };
  await StorageUtil.putObject(userData, profileData);
  await StorageUtil.putBoolean(isUserCreated, true);
  update();
  Get.offAllNamed(Routes.homePage);
}
}
