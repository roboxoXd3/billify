import 'package:billify/Util/app_colors.dart';
import 'package:billify/model/product_model.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:billify/services/pdf_service.dart';
import 'package:billify/features/inventory/services/database_helper.dart';
import 'package:billify/UI/controller/home_controller.dart';

class DataDetailView extends GetView<HomeController> {
  final ProductResponse? billData;
  final PdfService _pdfService = PdfService();
  DataDetailView({super.key, this.billData});

  @override
  Widget build(BuildContext context) {
    double subtotal = 0.0;
    double totalDiscount = 0.0;

    // Calculate totals
    for (var item in billData!.productData!) {
      double itemTotal = double.parse(item.totalAmount.validate(value: "0"));
      double itemDiscount = double.parse(item.discount.validate(value: "0"));
      subtotal += itemTotal;
      totalDiscount += itemDiscount;
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: whiteColor),
        ),
        title: Text(
          "bill_detail".tr,
          style: const TextStyle(color: whiteColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded, color: Colors.white),
            onPressed: () => _pdfService.generateAndPrintBill(billData!),
          ),
          IconButton(
            icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
            onPressed: () async {
              await _pdfService.saveAsPdf(billData!);
              Get.snackbar(
                'success'.tr,
                'pdf_saved'.tr,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () => _pdfService.generateAndShareBill(billData!),
          ),
          20.width
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cardview(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("bill_number".tr,
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(billData!.customerDetails!.billNumber.validate(),
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  )),
                  10.height,
                  customerDetailCard(context),
                  10.height,
                  cardview(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("items".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 18)),
                      const Divider(),
                      ListView.builder(
                        itemCount: billData!.productData!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var item = billData!.productData![index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName.validate(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        5.height,
                                        Text(
                                          "Qty: ${item.qty.validate(value: "0")} × ₹${item.amount.validate(value: "0")}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "₹${item.totalAmount.validate(value: "0")}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        if (item.discount
                                                .validate(value: "0") !=
                                            "0")
                                          Text(
                                            "Discount: ${item.discount.validate(value: "0")}%",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(color: Colors.green),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (index != billData!.productData!.length - 1)
                                const Divider(),
                            ],
                          );
                        },
                      ),
                      const Divider(),
                      // Bill Summary
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("subtotal".tr,
                                  style: Theme.of(context).textTheme.bodyLarge),
                              Text("₹$subtotal",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                          10.height,
                          if (totalDiscount > 0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("total_discount".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.green)),
                                Text("-₹$totalDiscount",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.green)),
                              ],
                            ),
                            10.height,
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("grand_total".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.bold)),
                              Text(
                                "₹${billData!.customerDetails!.grandTotal.validate()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
                  10.height,
                  cardview(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("bill_date".tr,
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(billData!.customerDetails!.createdAt.validate(),
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  )),
                ],
              ),
            ),
          ),
          // Delete Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: Text('delete_bill'.tr),
                    content: Text('delete_confirmation'.tr),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('cancel'.tr),
                      ),
                      TextButton(
                        onPressed: () async {
                          await DatabaseHelper.instance.deleteBill(
                              billData!.customerDetails!.billNumber.validate());
                          Get.back(); // Close dialog
                          Get.back(); // Return to bills list
                          Get.find<HomeController>()
                              .loadBills(); // Refresh bills list
                          Get.snackbar(
                            'success'.tr,
                            'bill_deleted'.tr,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        child: Text(
                          'delete'.tr,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'delete_bill'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container customerDetailCard(BuildContext context) {
    return cardview(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("customer_details".tr,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("customer_name".tr,
                style: Theme.of(context).textTheme.bodyLarge),
            Text(billData!.customerDetails!.name.validate(),
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("customer_number".tr,
                style: Theme.of(context).textTheme.bodyLarge),
            Text(billData!.customerDetails!.phoneNumber.validate(),
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("customer_location".tr,
                style: Theme.of(context).textTheme.bodyLarge),
            Text(billData!.customerDetails!.location.validate(),
                style: Theme.of(context).textTheme.titleMedium),
          ],
        )
      ],
    ));
  }

  Container cardview(Widget childView, {BorderRadius? borderRadius}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4, left: 20, right: 20),
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
