import 'package:billify/UI/controller/business_controller.dart';
import 'package:get/get.dart';

class BusinessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(BusinessController.new);
  }
  
}