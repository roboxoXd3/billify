import 'package:billify/UI/controller/template_controller.dart';
import 'package:billify/Util/app_colors.dart';
import 'package:billify/Util/common_method/common_textField.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../navigation/app_pages.dart';

class TemplateFormView extends StatelessWidget {
  const TemplateFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TemplateFormController>(
      init: TemplateFormController(),
      builder: (controller) => Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: whiteColor)),
            title: const Text(
              "Add Bill",
              style: TextStyle(color: whiteColor),
            ),
          ),
          body: Column(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: controller.templateKey,
                    child: Column(
                      children: [
                        10.height,
                        billNumberHeader(controller),
                        10.height,
                        customerDetailForm(controller),
                        if (controller.isOpticalTemplate) 10.height,
                        if (controller.isOpticalTemplate)
                          opticalTemplatePrescritpionForm(controller),
                        10.height,
                        cardview(
                            controller,
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Items",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    6.width,
                                    const Icon(Icons.add_circle_outline_rounded)
                                        .onTap(() {
                                      Get.toNamed(
                                        Routes.inventory,
                                        arguments: {'isSelecting': true},
                                      )?.then((selectedProducts) {
                                        if (selectedProducts != null) {
                                          if (controller
                                              .productControllers.isEmpty) {
                                            controller.addProductEntry();
                                          }
                                          controller.addSelectedProducts(
                                              selectedProducts);
                                        }
                                      });
                                    })
                                  ],
                                ),
                                if (controller.isOpticalTemplate)
                                  opticalTemplateItems(controller),
                                if (!controller.isOpticalTemplate)
                                  productTemplateItems(controller)
                              ],
                            )),
                        10.height,
                      ],
                    ).paddingSymmetric(horizontal: 20),
                  ),
                ),
              ).expand(),
              cardview(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  controller,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Total: ${controller.calculateTotalAmount(isOpticalTemplate: controller.isOpticalTemplate)}",
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        child: Row(
                          children: [
                            const Text(
                              "Save",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            6.width,
                            const Icon(Icons.save_rounded),
                          ],
                        ),
                      ).onTap(() {
                        controller.saveProductData();
                      })
                    ],
                  ))
            ],
          )),
    );
  }

  ListView productTemplateItems(TemplateFormController controller) {
    return ListView.builder(
        itemCount: controller.productControllers.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var item = controller.productControllers[index];
          if (item.productNameController.text.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                4.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.productNameController.text,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(item.amountController.text,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        hint: 'Quantity',
                        controller: item.qtyController,
                        keyboardType: TextInputType.number,
                        onChange: (value) {
                          item.calculateTotal();
                          controller.update();
                        },
                      ),
                    ),
                    10.width,
                    Expanded(
                      child: DefaultTextField(
                        hint: 'Discount %',
                        controller: item.discountController,
                        keyboardType: TextInputType.number,
                        onChange: (value) {
                          item.calculateTotal();
                          controller.update();
                        },
                      ),
                    ),
                  ],
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total: ${item.totalAmountController.text}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
                4.height,
                index == controller.productControllers.length - 1
                    ? const IgnorePointer()
                    : const Divider()
              ],
            );
          }
          return const IgnorePointer();
        });
  }

  ListView opticalTemplateItems(TemplateFormController controller) {
    return ListView.builder(
        itemCount: controller.opticalProductController.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var item = controller.opticalProductController[index];
          if (item.frameNameController.text.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                4.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.frameNameController.text,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(item.totalAmountController.text,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
                4.height,
                Text("Frame Price. ${item.framePriceController.text}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                4.height,
                index == controller.productControllers.length - 1
                    ? const IgnorePointer()
                    : const Divider()
              ],
            );
          }
          return const IgnorePointer();
        });
  }

  Container customerDetailForm(TemplateFormController controller) {
    return cardview(
        controller,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Customer Detail",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            10.height,
            DefaultTextField(
              validator: (v) =>
                  v.validate().trim().isEmpty ? "please enter your name" : null,
              hint: 'Enter your name',
              keyboardType: TextInputType.name,
              controller: controller.customerName,
            ),
            10.height,
            DefaultTextField(
              validator: (v) =>
                  v.validate().trim().isEmpty ? "please enter your age" : null,
              hint: 'Enter your Age',
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              controller: controller.customerAge,
            ),
            10.height,
            DefaultTextField(
              validator: (v) {
                if (v.validate().isEmpty) {
                  return "Please enter your phone number";
                }

                if (v!.length != 10) {
                  return "Please enter a valid 10-digit phone number";
                }

                return null;
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ],
              hint: 'Enter your phone number',
              keyboardType: TextInputType.number,
              controller: controller.customerNumber,
            ),
            10.height,
            DefaultTextField(
              autoValidaMode: AutovalidateMode.disabled,
              hint: 'Enter your location',
              keyboardType: TextInputType.name,
              controller: controller.customerLocation,
            ),
          ],
        ));
  }

  Container opticalTemplatePrescritpionForm(TemplateFormController controller) {
    return cardview(
        controller,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Prescritpion Detail",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            10.height,
            const Text("Right Eye",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            10.height,
            Row(
              children: [
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty ? "" : null,
                  hint: 'Spherical',
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                  controller: controller.rightSphController,
                ).expand(),
                6.width,
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty ? "" : null,
                  hint: 'Cylindrical',
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                  controller: controller.rightCylController,
                ).expand(),
                6.width,
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty ? "" : null,
                  hint: 'axis',
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                  controller: controller.rightAxisController,
                ).expand(),
              ],
            ),
            10.height,
            const Text("Left Eye",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            10.height,
            Row(
              children: [
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty ? "" : null,
                  hint: 'Spherical',
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                  controller: controller.leftSphController,
                ).expand(),
                6.width,
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty ? "" : null,
                  hint: 'Cylindrical',
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                  controller: controller.leftCylController,
                ).expand(),
                6.width,
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty ? "" : null,
                  hint: 'axis',
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                  controller: controller.leftAxisController,
                ).expand(),
              ],
            ),
            10.height,
            const Text("Eye Power",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            10.height,
            Row(
              children: [
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty ? "" : null,
                  hint: 'Left',
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  keyboardType: TextInputType.number,
                  controller: controller.leftPowerController,
                ).expand(),
                6.width,
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty ? "" : null,
                  hint: 'Right',
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  keyboardType: TextInputType.number,
                  controller: controller.rightPowerController,
                ).expand(),
              ],
            ),
            const Text("Visual Acuity",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            10.height,
            Row(
              children: [
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty ? "" : null,
                  hint: 'Left',
                  keyboardType: TextInputType.name,
                  controller: controller.leftVisualController,
                ).expand(),
                6.width,
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty ? "" : null,
                  hint: 'Right',
                  keyboardType: TextInputType.name,
                  controller: controller.rightVisualController,
                ).expand(),
              ],
            ),
            10.height,
            const Text("Other Medical Issue",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            10.height,
            DefaultTextField(
              hint: "Enter any other medical issues here",
              keyboardType: TextInputType.name,
              controller: controller.otherMedicalController,
            )
          ],
        ));
  }

  Container billNumberHeader(TemplateFormController controller) {
    return cardview(
        controller,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bill Number",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              controller.billNumber,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            )
          ],
        ));
  }

  Container cardview(TemplateFormController controller, Widget childView,
      {BorderRadius? borderRadius}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: whiteColor.withOpacity(0.2),
              offset: const Offset(0, 0),
              blurRadius: 6,
            ),
          ]),
      child: childView,
    );
  }
}
