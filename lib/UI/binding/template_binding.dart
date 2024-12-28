import 'package:billify/UI/controller/template_controller.dart';
import 'package:get/get.dart';

class TemplateFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(TemplateFormController.new);
  }
  
}