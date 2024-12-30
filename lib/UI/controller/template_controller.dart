import 'dart:convert';

import 'package:billify/Util/constant.dart';
import 'package:billify/model/addLineItem.dart';
import 'package:billify/storage_/StorageUtil.dart';
import 'package:billify/storage_/storage_const.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TemplateFormController extends GetxController {
  String billNumber = '',
      totalAmount = '',
      grandTotalAmount = '',
      productType = '';
  TextEditingController customerName = TextEditingController();
  TextEditingController customerAge = TextEditingController();
  TextEditingController customerLocation = TextEditingController();
  TextEditingController customerNumber = TextEditingController();
  TextEditingController rightSphController = TextEditingController();
  TextEditingController rightCylController = TextEditingController();
  TextEditingController rightAxisController = TextEditingController();
  TextEditingController leftSphController = TextEditingController();
  TextEditingController leftCylController = TextEditingController();
  TextEditingController leftAxisController = TextEditingController();
  TextEditingController leftPowerController = TextEditingController();
  TextEditingController rightPowerController = TextEditingController();
  TextEditingController leftVisualController = TextEditingController();
  TextEditingController rightVisualController = TextEditingController();
  TextEditingController otherMedicalController = TextEditingController();

  var templateKey = GlobalKey<FormState>();

  List addMultipleField = List.empty(growable: true);
  bool enableButton = false;
  List<ProductController> productControllers = List.empty(growable: true);
  List<OpticalProductController> opticalProductController =
      List.empty(growable: true);
  bool isOpticalTemplate = false;
  var argumentData = Get.arguments;

  @override
  void onInit() {
    if (argumentData != null) {
      isOpticalTemplate = argumentData['isOpticalTemplate'];
    }
    billNumber = BillNumberGenerator.generate();

    super.onInit();
  }

  void addProductEntry() {
    if (isOpticalTemplate) {
      opticalProductController.add(
        OpticalProductController(
          frameNameController: TextEditingController(),
          framePriceController: TextEditingController(),
          lensNameController: TextEditingController(),
          lensPriceController: TextEditingController(),
          coatingController: TextEditingController(),
          coatingPriceController: TextEditingController(),
          discountController: TextEditingController(),
          totalAmountController: TextEditingController(),
        ),
      );
    } else {
      productControllers.add(
        ProductController(
          productNameController: TextEditingController(),
          qtyController: TextEditingController(),
          amountController: TextEditingController(),
          discountController: TextEditingController(),
          totalAmountController: TextEditingController(),
        ),
      );
    }
    update();
  }

  validateForm() {
    enableButton = true;

    if (isOpticalTemplate) {
      for (int i = 0; i < opticalProductController.length; i++) {
        var opticalProduct = opticalProductController[i];

        if (opticalProduct.frameNameController.text.isEmpty ||
            opticalProduct.framePriceController.text.isEmpty ||
            opticalProduct.lensNameController.text.isEmpty ||
            opticalProduct.lensPriceController.text.isEmpty ||
            opticalProduct.coatingController.text.isEmpty ||
            opticalProduct.coatingPriceController.text.isEmpty ||
            opticalProduct.discountController.text.isEmpty ||
            opticalProduct.totalAmountController.text.isEmpty) {
          enableButton = false;
        }
      }
    } else {
      for (int i = 0; i < productControllers.length; i++) {
        var product = productControllers[i];

        if (product.productNameController.text.isEmpty ||
            product.qtyController.text.isEmpty ||
            product.amountController.text.isEmpty ||
            product.discountController.text.isEmpty ||
            product.totalAmountController.text.isEmpty) {
          enableButton = false;
        }
      }
    }

    update();
  }

  saveProductData() async {
    if (templateKey.currentState!.validate()) {
      if (enableButton == false) {
        Fluttertoast.showToast(msg: "Please add item.");
        return;
      }
      Map<String, dynamic> customerDetails = {
        'billNumber': billNumber,
        'name': customerName.text,
        'age': customerAge.text,
        'phoneNumber': customerNumber.text,
        'location': customerLocation.text,
        'created_at': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'productType': productType,
        'grandTotal': grandTotalAmount,
        'rightSph': rightSphController.text,
        'rightCyl': rightCylController.text,
        'rightAxis': rightAxisController.text,
        'leftSph': leftSphController.text,
        'leftCyl': leftCylController.text,
        'leftAxis': leftAxisController.text,
        'leftPower': leftPowerController.text,
        'rightPower': rightPowerController.text,
        'leftVisual': leftVisualController.text,
        'rightVisual': rightVisualController.text,
        'otherMedical': otherMedicalController.text,
      };

      List<Map<String, dynamic>> productData;
      if (isOpticalTemplate) {
        productData = opticalProductController.map((product) {
          return {
            'productName': product.frameNameController.text,
            'framePrice': product.framePriceController.text,
            'lensName': product.lensNameController.text,
            'lensPrice': product.lensPriceController.text,
            'coating': product.coatingController.text,
            'coatingPrice': product.coatingPriceController.text,
            'discount': product.discountController.text,
            'totalAmount': product.totalAmountController.text,
          };
        }).toList();
      } else {
        productData = productControllers.map((product) {
          return {
            'productName': product.productNameController.text,
            'qty': product.qtyController.text,
            'amount': product.amountController.text,
            'discount': product.discountController.text,
            'totalAmount': product.totalAmountController.text,
          };
        }).toList();
      }

      Map<String, dynamic> customerData = {
        'customerDetails': customerDetails,
        'productData': productData,
      };

      String? existingDataJson = StorageUtil.getString(dashBoardItem);
      List<Map<String, dynamic>> dashboardData = [];

      if (existingDataJson.validate().isNotEmpty) {
        final decodedData = json.decode(existingDataJson);

        if (decodedData is Map<String, dynamic>) {
          dashboardData = [decodedData];
        } else if (decodedData is List) {
          dashboardData = List<Map<String, dynamic>>.from(decodedData);
        }
      }

      dashboardData.add(customerData);

      String updatedDataJson = json.encode(dashboardData);
      await StorageUtil.putString(dashBoardItem, updatedDataJson);

      Get.back();
    }
    update();
  }

  void calculateTotal(qty, amountText, discountAmount) {
    try {
      final quantity = int.tryParse(qty) ?? 0;
      final amount = double.tryParse(amountText) ?? 0.0;
      final discount = double.tryParse(discountAmount) ?? 0.0;

      final total =
          (quantity * amount) - ((quantity * amount) * (discount / 100));

      totalAmount = total.toStringAsFixed(2);
    } catch (e) {
      totalAmount = "0.00";
    }
    update();
  }

  void opticalCalculateTotal(String framePrice, String lensPrice,
      String coatingPrice, String discountAmount) {
    try {
      final frame = double.tryParse(framePrice) ?? 0.0;
      final lens = double.tryParse(lensPrice) ?? 0.0;
      final coating = double.tryParse(coatingPrice) ?? 0.0;
      final discount = double.tryParse(discountAmount) ?? 0.0;

      final subtotal = frame + lens + coating;

      final discountValue = subtotal * (discount / 100);
      final total = subtotal - discountValue;

      totalAmount = total.toStringAsFixed(2);
    } catch (e) {
      totalAmount = "0.00";
    }
    update();
  }

  double calculateTotalAmount({bool isOpticalTemplate = false}) {
    if (isOpticalTemplate) {
      return opticalProductController.fold(0.0, (sum, item) {
        double framePrice =
            double.tryParse(item.framePriceController.text) ?? 0.0;
        double lensPrice =
            double.tryParse(item.lensPriceController.text) ?? 0.0;
        double coatingPrice =
            double.tryParse(item.coatingPriceController.text) ?? 0.0;
        double discount = double.tryParse(item.discountController.text) ?? 0.0;

        double totalAmount = framePrice + lensPrice + coatingPrice;
        totalAmount -= totalAmount * (discount / 100);
        grandTotalAmount = "${sum + totalAmount}";

        return sum + totalAmount;
      });
    } else {
      return productControllers.fold(0.0, (sum, item) {
        double totalAmount =
            double.tryParse(item.totalAmountController.text) ?? 0.0;
        grandTotalAmount = "${sum + totalAmount}";
        return sum + totalAmount;
      });
    }
  }
}
