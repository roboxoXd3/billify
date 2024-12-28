import 'package:billify/UI/controller/template_controller.dart';
import 'package:billify/Util/app_colors.dart';
import 'package:billify/Util/common_method/common_textField.dart';
import 'package:billify/Util/common_method/gradient_button.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTemplateData extends StatelessWidget {
  const AddTemplateData({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TemplateFormController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: whiteColor)),
          ),
          body: Column(children: [
            ListView.builder(
              itemCount: controller.isOpticalTemplate
                  ? controller.opticalProductController.length
                  : controller.productControllers.length,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (controller.isOpticalTemplate) {
                  final opticalProduct =
                      controller.opticalProductController[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextField(
                        controller: opticalProduct.frameNameController,
                        validator: (v) => v?.trim().isEmpty ?? true
                            ? "Please enter the frame name"
                            : null,
                        hint: 'Frame Name',
                        onChange: (p0) {
                          controller.validateForm();
                        },
                      ),
                      10.height,
                      DefaultTextField(
                        controller: opticalProduct.lensNameController,
                        validator: (v) => v?.trim().isEmpty ?? true
                            ? "Please enter the Lens name"
                            : null,
                        hint: 'Lens Name',
                        onChange: (p0) {
                          controller.validateForm();
                        },
                      ),
                      10.height,
                      Row(
                        children: [
                          DefaultTextField(
                            controller: opticalProduct.framePriceController,
                            validator: (v) =>
                                v?.trim().isEmpty ?? true ? "" : null,
                            hint: 'Frame Price',
                            keyboardType: TextInputType.number,
                            onChange: (p0) {
                              controller.opticalCalculateTotal(
                                  opticalProduct.framePriceController.text,
                                  opticalProduct.lensPriceController.text,
                                  opticalProduct.coatingPriceController.text,
                                  opticalProduct.discountController.text);
                              opticalProduct.totalAmountController.text =
                                  controller.totalAmount;
                              controller.validateForm();
                            },
                          ).expand(),
                          10.width,
                          DefaultTextField(
                            controller: opticalProduct.lensPriceController,
                            validator: (v) =>
                                v?.trim().isEmpty ?? true ? "" : null,
                            hint: 'Lens Price',
                            keyboardType: TextInputType.number,
                            onChange: (p0) {
                              controller.opticalCalculateTotal(
                                  opticalProduct.framePriceController.text,
                                  opticalProduct.lensPriceController.text,
                                  opticalProduct.coatingPriceController.text,
                                  opticalProduct.discountController.text);
                              opticalProduct.totalAmountController.text =
                                  controller.totalAmount;
                              controller.validateForm();
                            },
                          ).expand(),
                        ],
                      ),
                      10.height,
                      DefaultTextField(
                        controller: opticalProduct.coatingController,
                        validator: (v) => v?.trim().isEmpty ?? true
                            ? "Please enter coating details"
                            : null,
                        hint: 'Coating',
                        onChange: (p0) {
                          controller.validateForm();
                        },
                      ),
                      10.height,
                      DefaultTextField(
                        controller: opticalProduct.coatingPriceController,
                        validator: (v) => v?.trim().isEmpty ?? true
                            ? "Please enter coating price"
                            : null,
                        hint: 'Coating Price',
                        keyboardType: TextInputType.number,
                        onChange: (p0) {
                          controller.opticalCalculateTotal(
                              opticalProduct.framePriceController.text,
                              opticalProduct.lensPriceController.text,
                              opticalProduct.coatingPriceController.text,
                              opticalProduct.discountController.text);
                          opticalProduct.totalAmountController.text =
                              controller.totalAmount;
                          controller.validateForm();
                          controller.validateForm();
                        },
                      ),
                      10.height,
                      Row(
                        children: [
                          DefaultTextField(
                            controller: opticalProduct.discountController,
                            validator: (v) => v?.trim().isEmpty ?? true
                                ? "Please enter discount"
                                : null,
                            hint: 'Discount (%)',
                            keyboardType: TextInputType.number,
                            onChange: (p0) {
                              controller.opticalCalculateTotal(
                                  opticalProduct.framePriceController.text,
                                  opticalProduct.lensPriceController.text,
                                  opticalProduct.coatingPriceController.text,
                                  opticalProduct.discountController.text);
                              opticalProduct.totalAmountController.text =
                                  controller.totalAmount;
                              controller.validateForm();
                            },
                          ).expand(),
                          10.width,
                          DefaultTextField(
                            controller: opticalProduct.totalAmountController,
                            hint: '',
                            readOnly: true,
                          ).expand(),
                        ],
                      ),
                      const Divider(),
                    ],
                  ).paddingSymmetric(vertical: 10);
                } else {
                  final product = controller.productControllers[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextField(
                        controller: product.productNameController,
                        validator: (v) => v?.trim().isEmpty ?? true
                            ? "Please enter the product name"
                            : null,
                        hint: 'Enter your product name',
                        keyboardType: TextInputType.text,
                        onChange: (p0) {
                          controller.validateForm();
                        },
                      ),
                      10.height,
                      Row(
                        children: [
                          DefaultTextField(
                            controller: product.qtyController,
                            validator: (v) =>
                                v?.trim().isEmpty ?? true ? "" : null,
                            hint: 'Quantity',
                            keyboardType: TextInputType.number,
                            onChange: (p0) {
                              controller.calculateTotal(
                                  product.qtyController.text,
                                  product.amountController.text,
                                  product.discountController.text);
                              product.totalAmountController.text =
                                  controller.totalAmount;
                              controller.validateForm();
                            },
                          ).expand(),
                          10.width,
                          DefaultTextField(
                            controller: product.amountController,
                            validator: (v) =>
                                v?.trim().isEmpty ?? true ? "" : null,
                            hint: 'Amount',
                            keyboardType: TextInputType.number,
                            onChange: (p0) {
                              controller.calculateTotal(
                                  product.qtyController.text,
                                  product.amountController.text,
                                  product.discountController.text);
                              product.totalAmountController.text =
                                  controller.totalAmount;
                              controller.validateForm();
                            },
                          ).expand(),
                        ],
                      ),
                      10.height,
                      Row(
                        children: [
                          DefaultTextField(
                            controller: product.discountController,
                            validator: (v) =>
                                v?.trim().isEmpty ?? true ? "" : null,
                            hint: 'Discount (%)',
                            keyboardType: TextInputType.number,
                            onChange: (p0) {
                              controller.calculateTotal(
                                  product.qtyController.text,
                                  product.amountController.text,
                                  product.discountController.text);
                              product.totalAmountController.text =
                                  controller.totalAmount;
                              controller.validateForm();
                            },
                          ).expand(),
                          10.width,
                          DefaultTextField(
                            controller: product.totalAmountController,
                            hint: '',
                            readOnly: true,
                          ).expand(),
                        ],
                      ),
                      10.height,
                      const Divider(),
                    ],
                  ).paddingSymmetric(vertical: 10);
                }
              },
            ).paddingSymmetric(horizontal: 20).expand(),
            TextButton(
                onPressed: () {
                  controller.addProductEntry();
                },
                child: const Text("Add another product",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: orangeColor,
                        decoration: TextDecoration.underline,
                        decorationColor: orangeColor,
                        fontSize: 16))),
            GradientElevatedButton(
              onPressed: !controller.enableButton
                  ? null
                  : () {
                      print(controller.productControllers);
                      Get.back();
                    },
              child: const Text("Save",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ).paddingSymmetric(horizontal: 20, vertical: 10)
          ]),
        );
      },
    );
  }
}
