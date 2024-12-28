import 'package:billify/UI/controller/business_controller.dart';
import 'package:billify/Util/app_colors.dart';
import 'package:billify/Util/common_method/common_dropdown.dart';
import 'package:billify/Util/common_method/common_textField.dart';
import 'package:billify/Util/common_method/gradient_button.dart';
import 'package:billify/Util/extensions/widget.dart';
import 'package:billify/model/addLineItem.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BusinessCreateView extends StatelessWidget {
  const BusinessCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(
      init: BusinessController(),
      builder: (controller) => Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Form(
            key: controller.formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.height,
                Text("Let's set up your business",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: whiteColor)),
                30.height,
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty
                      ? "please enter your business name"
                      : null,
                  hint: 'Enter your business name',
                  keyboardType: TextInputType.name,
                  controller: controller.businessNameController,
                ),
                20.height,
                DefaultTextField(
                  validator: (v) => v.validate().trim().isEmpty
                      ? "please enter your name"
                      : null,
                  hint: 'Enter your name',
                  keyboardType: TextInputType.name,
                  controller: controller.userNameController,
                ),
                20.height,
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
                  controller: controller.phoneNumberController,
                ),
                20.height,
                DefaultDropdownField<FormTemplateModel>(
                  items: controller.templates,
                  hint: 'Select Template',
                  validator: (value) =>
                      value == null || value.formName!.trim().isEmpty
                          ? "Please select a template"
                          : null,
                  onChanged: (value) {
                    controller.selectedTemplateName = value?.formName;
                    controller.selectedTemplateType = value?.formType;
                    print(controller.selectedTemplateType);
                    controller.update();
                  },
                  itemBuilder: (context, item) => Text(
                    item.formName.validate(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  selectedBuilder: (context, selectedItem) => Text(
                    selectedItem?.formName ?? 'Select Template',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                40.height,
                GradientElevatedButton(
                  child: const Text(
                    "Create",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onPressed: () {
                    if (controller.formkey.currentState!.validate()) {
                      controller.onSubmit();
                    }
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 20).safe(),
          ),
        ),
      ),
    );
  }
}
