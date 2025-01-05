import 'dart:math';

import 'package:billify/UI/controller/home_controller.dart';
import 'package:billify/UI/view/home.detail_view.dart';
import 'package:billify/Util/app_colors.dart';
import 'package:billify/navigation/app_pages.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../translations/language_controller.dart';
import '../../widgets/language_selector.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    Get.put(LanguageController());

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        title: Text("dashboard".tr, style: const TextStyle(color: whiteColor)),
        actions: [
          const LanguageSelector(),
          IconButton(
            icon: const Icon(Icons.receipt_long, color: whiteColor),
            onPressed: () => Get.toNamed(Routes.bills),
            tooltip: 'bills'.tr,
          ),
          IconButton(
            icon: const Icon(Icons.inventory, color: whiteColor),
            onPressed: () => Get.toNamed(Routes.inventory),
            tooltip: 'inventory'.tr,
          ),
        ],
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Cards
                Row(
                  children: [
                    _buildStatCard(
                      "total_sales".tr,
                      "₹${controller.getTotalSales()}",
                      Icons.monetization_on,
                      Colors.green,
                    ).expand(),
                    16.width,
                    _buildStatCard(
                      "total_bills".tr,
                      "${controller.getTotalBills()}",
                      Icons.receipt_long,
                      Colors.blue,
                    ).expand(),
                  ],
                ),
                16.height,
                Row(
                  children: [
                    _buildStatCard(
                      "this_month".tr,
                      "₹${controller.getCurrentMonthSales()}",
                      Icons.calendar_today,
                      Colors.orange,
                    ).expand(),
                    16.width,
                    _buildStatCard(
                      "today".tr,
                      "₹${controller.getTodaySales()}",
                      Icons.today,
                      Colors.purple,
                    ).expand(),
                  ],
                ),
                24.height,

                // Recent Bills Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "recent_bills".tr,
                      style: const TextStyle(
                        color: whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.bills),
                      child: Text(
                        "view_all".tr,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                10.height,
                _buildRecentBills(controller),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.templateForm),
        tooltip: 'add_bill'.tr,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: whiteColor.withOpacity(0.1),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          8.height,
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          4.height,
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBills(HomeController controller) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: min(3, controller.dashboardData.length),
      itemBuilder: (context, index) {
        final bill = controller.dashboardData[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () => Get.to(() => DataDetailView(billData: bill)),
            title: Text(bill.customerDetails?.name ?? ''),
            subtitle: Text(bill.customerDetails?.billNumber ?? ''),
            trailing: Text(
              "₹${bill.customerDetails?.grandTotal ?? '0'}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
