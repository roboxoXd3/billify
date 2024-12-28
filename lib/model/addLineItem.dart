import 'package:flutter/material.dart';

class ProductController {
  TextEditingController productNameController;
  TextEditingController qtyController;
  TextEditingController amountController;
  TextEditingController discountController;
  TextEditingController totalAmountController;

  ProductController(
      {required this.productNameController,
      required this.qtyController,
      required this.amountController,
      required this.discountController,
      required this.totalAmountController});
}

class OpticalProductController {
  TextEditingController frameNameController;
  TextEditingController framePriceController;
  TextEditingController lensNameController;
  TextEditingController lensPriceController;
  TextEditingController coatingController;
  TextEditingController coatingPriceController;
  TextEditingController discountController;
  TextEditingController totalAmountController;

  OpticalProductController({
    required this.frameNameController,
    required this.framePriceController,
    required this.lensPriceController,
    required this.lensNameController,
    required this.coatingController,
    required this.coatingPriceController,
    required this.discountController,
    required this.totalAmountController,
  });
}

class FormTemplateModel {
  String? formName;
  String? formType;

  FormTemplateModel({this.formName, this.formType});
}
