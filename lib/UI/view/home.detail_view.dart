import 'package:billify/Util/app_colors.dart';
import 'package:billify/model/product_model.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:billify/services/pdf_service.dart';

class DataDetailView extends StatefulWidget {
  ProductResponse? billData;
  DataDetailView({super.key, this.billData});

  @override
  State<DataDetailView> createState() => _DataDetailViewState();
}

class _DataDetailViewState extends State<DataDetailView> {
  final PdfService _pdfService = PdfService();

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "Bill Detail",
          style: TextStyle(color: whiteColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded, color: Colors.white),
            onPressed: () => _pdfService.generateAndPrintBill(widget.billData!),
          ),
          20.width
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cardview(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bill Number",
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(widget.billData!.customerDetails!.billNumber.validate(),
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            )),
            10.height,
            customerDetailCard(context),
            10.height,
            cardview(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Items",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 18)),
                ListView.builder(
                  itemCount: widget.billData!.productData!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = widget.billData!.productData![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.productName.validate(),
                            style: Theme.of(context).textTheme.titleMedium),
                        6.height,
                        Text("Discount: ${item.discount.validate(value: "0")}%",
                            style: Theme.of(context).textTheme.titleMedium),
                        6.height,
                        Text("Total: ${item.totalAmount.validate()}",
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    );
                  },
                )
              ],
            )),
          ],
        ),
      ),
    );
  }

  Container customerDetailCard(BuildContext context) {
    return cardview(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer Details",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Cutomer Name", style: Theme.of(context).textTheme.bodyLarge),
            Text(widget.billData!.customerDetails!.name.validate(),
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Customer Number",
                style: Theme.of(context).textTheme.bodyLarge),
            Text(widget.billData!.customerDetails!.phoneNumber.validate(),
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Customer Location",
                style: Theme.of(context).textTheme.bodyLarge),
            Text(widget.billData!.customerDetails!.location.validate(),
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
