import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';

import '../../Util/app_colors.dart';
import '../controller/home_controller.dart';
import 'home.detail_view.dart';

class BillsView extends GetView<HomeController> {
  const BillsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: white,
            ),
          ),
          title: Text(
            "bills".tr,
            style: const TextStyle(color: white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt, color: white),
              onPressed: () => _showDateFilterDialog(context, controller),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                onChanged: (value) => controller.searchBills(value),
                decoration: InputDecoration(
                  hintText: 'search_bills'.tr,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            // Date Filter Chips
            if (controller.selectedStartDate != null ||
                controller.selectedEndDate != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (controller.selectedStartDate != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Chip(
                                  label: Text(
                                      '${('from'.tr)}: ${DateFormat('dd/MM/yyyy').format(controller.selectedStartDate!)}'),
                                  onDeleted: () => controller.filterBillsByDate(
                                      null, controller.selectedEndDate),
                                ),
                              ),
                            if (controller.selectedEndDate != null)
                              Chip(
                                label: Text(
                                    '${('to'.tr)}: ${DateFormat('dd/MM/yyyy').format(controller.selectedEndDate!)}'),
                                onDeleted: () => controller.filterBillsByDate(
                                    controller.selectedStartDate, null),
                              ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.clearDateFilter(),
                      child: Text('clear'.tr),
                    ),
                  ],
                ),
              ),
            // Bills List
            Expanded(
              child: GetBuilder<HomeController>(
                builder: (controller) => ListView.builder(
                  itemCount: controller.filteredData.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemBuilder: (context, index) {
                    return controller.filteredData[index].customerDetails ==
                            null
                        ? const IgnorePointer()
                        : GestureDetector(
                            onTap: () => Get.to(() => DataDetailView(
                                billData: controller.filteredData[index])),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.filteredData[index]
                                                .customerDetails?.name ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "₹${controller.filteredData[index].customerDetails?.grandTotal ?? '0'}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.filteredData[index]
                                            .customerDetails?.billNumber ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'exportExcel',
              onPressed: () async {
                await controller.exportToExcel();
                Get.snackbar(
                  'success'.tr,
                  'bills_exported'.tr,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.file_download),
              label: Text('export_excel'.tr),
              backgroundColor: Colors.green,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDateFilterDialog(BuildContext context, HomeController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('filter_by_date'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('start_date'.tr),
              subtitle: Text(
                controller.selectedStartDate != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.selectedStartDate!)
                    : 'not_set'.tr,
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedStartDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: controller.selectedEndDate ??
                      DateTime.now(), // End date or today
                );
                if (date != null) {
                  controller.filterBillsByDate(
                      date, controller.selectedEndDate);
                }
                Get.back();
              },
            ),
            ListTile(
              title: Text('end_date'.tr),
              subtitle: Text(
                controller.selectedEndDate != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.selectedEndDate!)
                    : 'not_set'.tr,
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedEndDate ?? DateTime.now(),
                  firstDate: controller.selectedStartDate ??
                      DateTime(2000), // Start from selected start date
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  controller.filterBillsByDate(
                      controller.selectedStartDate, date);
                }
                Get.back();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearDateFilter();
              Get.back();
            },
            child: Text('clear'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }
}
