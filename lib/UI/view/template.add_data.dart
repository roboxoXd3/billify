// import 'package:billify/UI/controller/template_controller.dart';
// import 'package:billify/Util/app_colors.dart';
// import 'package:billify/Util/common_method/common_textField.dart';
// import 'package:billify/Util/common_method/gradient_button.dart';
// import 'package:ext_plus/ext_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AddTemplateData extends StatelessWidget {
//   const AddTemplateData({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<TemplateFormController>(
//       builder: (controller) {
//         return Scaffold(
//           backgroundColor: bgColor,
//           appBar: AppBar(
//             backgroundColor: bgColor,
//             automaticallyImplyLeading: false,
//             leading: IconButton(
//                 padding: EdgeInsets.zero,
//                 onPressed: () => Get.back(),
//                 icon: const Icon(Icons.arrow_back_ios_new_rounded,
//                     color: whiteColor)),
//           ),
//           body: Column(children: [
//             ListView.builder(
//               itemCount: controller.productControllers.length,
//               shrinkWrap: true,
//               physics: const AlwaysScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 final product = controller.productControllers[index];
//                 return Container(
//                   padding: const EdgeInsets.all(16),
//                   margin: const EdgeInsets.only(bottom: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             product.productNameController.text,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             '₹${product.amountController.text}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: product.qtyController,
//                               keyboardType: TextInputType.number,
//                               decoration: const InputDecoration(
//                                 labelText: 'Quantity',
//                                 border: OutlineInputBorder(),
//                               ),
//                               onChanged: (value) {
//                                 product.calculateTotal();
//                                 controller.validateForm();
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: TextField(
//                               controller: product.discountController,
//                               keyboardType: TextInputType.number,
//                               decoration: const InputDecoration(
//                                 labelText: 'Discount %',
//                                 border: OutlineInputBorder(),
//                               ),
//                               onChanged: (value) {
//                                 product.calculateTotal();
//                                 controller.validateForm();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             'Total: ₹${product.totalAmountController.text}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ).paddingSymmetric(horizontal: 20),
//             TextButton(
//                 onPressed: () {
//                   controller.addProductEntry();
//                 },
//                 child: const Text("Add another product",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: orangeColor,
//                         decoration: TextDecoration.underline,
//                         decorationColor: orangeColor,
//                         fontSize: 16))),
//             GradientElevatedButton(
//               onPressed: !controller.enableButton
//                   ? null
//                   : () {
//                       // Filter out empty products before saving
//                       controller.productControllers.removeWhere((product) =>
//                           product.productNameController.text.isEmpty &&
//                           product.qtyController.text.isEmpty &&
//                           product.amountController.text.isEmpty);
//                       print(controller.productControllers);
//                       Get.back();
//                     },
//               child: const Text("Save",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             ).paddingSymmetric(horizontal: 20, vertical: 10)
//           ]),
//         );
//       },
//     );
//   }
// }
