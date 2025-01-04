import 'package:billify/UI/controller/home_controller.dart';
import 'package:billify/UI/view/home.detail_view.dart';
import 'package:billify/Util/app_colors.dart';
import 'package:billify/navigation/app_pages.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:billify/services/pdf_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          title: const Text("Billing", style: TextStyle(color: whiteColor)),
        ),
        body: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: controller.searchController,
                style: const TextStyle(color: whiteColor),
                decoration: InputDecoration(
                  hintText: 'Search by name, bill number or phone',
                  hintStyle: TextStyle(color: whiteColor.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.search, color: whiteColor),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: whiteColor.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: whiteColor),
                  ),
                ),
                onChanged: (value) => controller.searchBills(value),
              ),
            ),
            // Bills List
            Expanded(
              child: controller.filteredData.isEmpty
                  ? Center(
                      child: Text(
                        controller.searchController.text.isEmpty
                            ? 'No bills found'
                            : 'No matching bills found',
                        style: const TextStyle(color: whiteColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.filteredData.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return controller.filteredData[index].customerDetails ==
                                null
                            ? const IgnorePointer()
                            : GestureDetector(
                                onTap: () {
                                  Get.to(() => DataDetailView(
                                      billData:
                                          controller.filteredData[index]));
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: whiteColor.withOpacity(0.2),
                                          offset: const Offset(0, 0),
                                          blurRadius: 6,
                                        ),
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              controller.filteredData[index]
                                                  .customerDetails!.billNumber
                                                  .validate(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          IconButton(
                                            icon: const Icon(Icons.share,
                                                color: Colors.blue),
                                            onPressed: () {
                                              PdfService().generateAndShareBill(
                                                  controller
                                                      .filteredData[index]);
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                          controller.filteredData[index]
                                              .customerDetails!.name
                                              .validate(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              controller.filteredData[index]
                                                  .customerDetails!.phoneNumber
                                                  .validate(),
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500)),
                                          Text(
                                              "Item: ${controller.filteredData[index].productData!.length}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
                onPressed: () {
                  Get.toNamed(Routes.templateForm, arguments: {
                    'isOpticalTemplate': controller.isOpticalTemplate
                  })!
                      .then(
                    (value) {
                      controller.fetchData();
                    },
                  );
                },
                child: const Icon(Icons.add_rounded)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                controller.exportMonthlyBills(
                    context, controller.dashboardData);
              },
              child: IntrinsicWidth(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      border: Border.all(color: whiteColor),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.file_download, color: whiteColor),
                        8.width,
                        const Text("Export Monthly Bills",
                            style: TextStyle(color: whiteColor)),
                      ],
                    )),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
