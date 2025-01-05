import 'dart:convert';

import 'package:billify/Util/constant.dart';
import 'package:billify/model/addLineItem.dart';
import 'package:billify/storage_/StorageUtil.dart';
import 'package:billify/storage_/storage_const.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../navigation/app_pages.dart';
import '../../features/inventory/services/database_helper.dart';
import 'home_controller.dart';

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
  List<ProductEntryController> productControllers = List.empty(growable: true);
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
    // Check if there are any empty products first
    bool hasEmptyProduct = false;

    if (isOpticalTemplate) {
      hasEmptyProduct = opticalProductController.any((product) =>
          product.frameNameController.text.isEmpty &&
          product.framePriceController.text.isEmpty);
    } else {
      hasEmptyProduct = productControllers.any((product) =>
          product.productNameController.text.isEmpty &&
          product.qtyController.text.isEmpty &&
          product.amountController.text.isEmpty);
    }

    // Only add new product if there are no empty ones
    if (!hasEmptyProduct) {
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
          ProductEntryController(),
        );
      }
      update();
    } else {
      Get.snackbar(
        'Warning',
        'Please fill the current product details first',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  validateForm() {
    enableButton = true;

    // First check if there are any products added
    if (productControllers.isEmpty) {
      enableButton = false;
      Get.snackbar(
        'Error',
        'Please add at least one product',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Then validate customer details
    if (customerName.text.isEmpty ||
        customerAge.text.isEmpty ||
        customerNumber.text.isEmpty) {
      enableButton = false;
      Get.snackbar(
        'Error',
        'Please fill all required customer details',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // For selected products from inventory, we only need to verify they exist
    bool hasValidProducts = productControllers.any((product) =>
        product.productNameController.text.isNotEmpty &&
        product.totalAmountController.text.isNotEmpty);

    if (!hasValidProducts) {
      enableButton = false;
      Get.snackbar(
        'Error',
        'Please add valid products',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    update();
  }

  saveProductData() async {
    if (templateKey.currentState!.validate()) {
      try {
        // First update inventory stock
        for (var productController in productControllers) {
          if (productController.productNameController.text.isNotEmpty) {
            final productName = productController.productNameController.text;
            final quantity = int.parse(productController.qtyController.text);

            print(
                'Updating stock for: $productName, Quantity: $quantity'); // Debug log

            final product =
                await DatabaseHelper.instance.getProductByName(productName);
            if (product != null) {
              final newStock = product.currentStock - quantity;
              if (newStock >= 0) {
                print(
                    'Old stock: ${product.currentStock}, New stock: $newStock'); // Debug log
                await DatabaseHelper.instance
                    .updateProductStock(product.sku, newStock);
              } else {
                throw Exception('Insufficient stock for $productName');
              }
            } else {
              print('Product not found: $productName'); // Debug log
            }
          }
        }

        // Then save bill details
        final billId = await DatabaseHelper.instance.insertBill({
          'billNumber': billNumber,
          'name': customerName.text,
          'age': customerAge.text,
          'phoneNumber': customerNumber.text,
          'location': customerLocation.text,
          'grandTotal':
              calculateTotalAmount(isOpticalTemplate: isOpticalTemplate),
          'createdAt': DateFormat('dd/MM/yyyy').format(DateTime.now()),
          'productType': isOpticalTemplate ? "2" : "1",
        });

        // Save bill items
        List<Map<String, dynamic>> billItems = productControllers
            .where((controller) =>
                controller.productNameController.text.isNotEmpty)
            .map((item) => {
                  'productName': item.productNameController.text,
                  'qty': item.qtyController.text,
                  'amount': item.amountController.text,
                  'totalAmount': item.totalAmountController.text,
                })
            .toList();

        await DatabaseHelper.instance.insertBillItems(billId, billItems);

        // Refresh bills list
        Get.find<HomeController>().loadBills();

        Get.back();
        Get.snackbar(
          'Success',
          'Bill saved successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        print('Error saving bill: $e'); // Debug log
        Get.snackbar(
          'Error',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
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

  void addSelectedProducts(List<dynamic> products) {
    // Clear any existing empty products first
    productControllers.removeWhere((controller) =>
        controller.productNameController.text.isEmpty &&
        controller.qtyController.text.isEmpty &&
        controller.amountController.text.isEmpty);

    // Add the selected products
    for (var product in products) {
      final controller = ProductEntryController();
      controller.productNameController.text = product.name;
      controller.qtyController.text = '1'; // Default quantity
      controller.amountController.text = product.sellingPrice.toString();
      controller.discountController.text = '0'; // Default discount
      controller.calculateTotal();
      productControllers.add(controller);
    }
    update();
  }

  void saveBill() {
    // Remove any empty products before saving
    productControllers.removeWhere((controller) =>
        controller.productNameController.text.isEmpty ||
        controller.qtyController.text.isEmpty ||
        controller.amountController.text.isEmpty);

    // Continue with saving logic
    // ...
  }
}

class ProductEntryController {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();

  void calculateTotal() {
    final qty = int.tryParse(qtyController.text) ?? 0;
    final amount = double.tryParse(amountController.text) ?? 0.0;
    final discount = double.tryParse(discountController.text) ?? 0.0;
    final total = (qty * amount) - ((qty * amount) * (discount / 100));
    totalAmountController.text = total.toStringAsFixed(2);
  }
}
