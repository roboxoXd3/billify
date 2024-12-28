import 'dart:convert';
import 'dart:io';
import 'package:billify/model/product_model.dart';
import 'package:billify/storage_/StorageUtil.dart';
import 'package:billify/storage_/storage_const.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  List<ProductResponse> dashboardData = List.empty(growable: true);
  bool isOpticalTemplate = false;
  @override
  void onInit() {
    var profileData = StorageUtil.getObject(userData);
    if (profileData.isNotEmpty) {
      var data = jsonDecode(profileData);
      String template = data['selectedTemplateType'];
      if (template == "1") {
        isOpticalTemplate = false;
      } else if (template == "2") {
        isOpticalTemplate = true;
      }
      update();
    }
    fetchData();
    super.onInit();
  }

  fetchData() async {
    var savedDataJson = StorageUtil.getString(dashBoardItem);

    if (savedDataJson.validate().isNotEmpty) {
      if (savedDataJson.validate().isNotEmpty) {
        dashboardData = (json.decode(savedDataJson) as List)
            .map((item) => ProductResponse.fromJson(item))
            .toList();
      }
    }
    update();
  }

  Future<void> exportMonthlyBills(
      BuildContext context, List<ProductResponse> bills) async {
    try {
      // Check Android version
      if (Platform.isAndroid) {
        if (await Permission.manageExternalStorage.request().isGranted) {
          // For Android 11 and above
          await Permission.manageExternalStorage.request();
        } else {
          // For Android 10 and below
          await Permission.storage.request();
        }
      }

      // Create Excel workbook and remove default sheet
      var excel = Excel.createExcel();

      // First create our Bills sheet
      var sheet = excel['Bills'];

      // Add headers
      sheet.appendRow([
        TextCellValue('Bill Number'),
        TextCellValue('Customer Name'),
        TextCellValue('Location'),
        TextCellValue('Phone Number'),
        TextCellValue('Date'),
        TextCellValue('Total Items'),
        TextCellValue('Total Amount'),
        TextCellValue('Type')
      ]);

      // Remove Sheet1 after creating Bills sheet
      if (excel.sheets.containsKey('Sheet1')) {
        excel.delete('Sheet1');
      }

      // Ensure only Bills sheet exists
      excel.sheets.removeWhere((key, value) => key != 'Bills');

      // Add data rows
      for (var bill in bills) {
        if (bill.customerDetails != null) {
          double totalAmount = 0;
          if (bill.productData != null) {
            totalAmount = bill.productData!.fold(
                0,
                (sum, item) =>
                    sum + (double.tryParse(item.totalAmount ?? '0') ?? 0));
          }

          sheet.appendRow([
            TextCellValue(bill.customerDetails!.billNumber.validate()),
            TextCellValue(bill.customerDetails!.name.validate()),
            TextCellValue(bill.customerDetails!.location.validate()),
            TextCellValue(bill.customerDetails!.phoneNumber.validate()),
            TextCellValue(bill.customerDetails!.createdAt.validate()),
            TextCellValue(bill.productData?.length.toString() ?? '0'),
            TextCellValue(totalAmount.toString()),
            TextCellValue(bill.customerDetails!.productType.validate())
          ]);
        }
      }

      // Save file
      String? filePath;
      if (Platform.isAndroid) {
        Directory? directory;
        if (await Directory('/storage/emulated/0/Download').exists()) {
          directory = Directory('/storage/emulated/0/Download');
        } else {
          directory = await getExternalStorageDirectory();
        }

        if (directory != null) {
          final now = DateTime.now();
          final fileName =
              'Billify_Report_${now.day}-${now.month}-${now.year}_${now.hour}-${now.minute}.xlsx';
          filePath = '${directory.path}/$fileName';
        }
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final now = DateTime.now();
        final fileName =
            'Billify_Report_${now.day}-${now.month}-${now.year}_${now.hour}-${now.minute}.xlsx';
        filePath = '${directory.path}/$fileName';
      }

      if (filePath == null) {
        throw Exception('Could not determine file path');
      }

      final file = File(filePath);
      var excelData = excel.save();

      if (excelData != null) {
        await file.writeAsBytes(excelData);
        Fluttertoast.showToast(
          msg: "Excel file saved to: $filePath",
          backgroundColor: Colors.green,
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        throw Exception('Failed to generate Excel data');
      }
    } catch (e) {
      print("Error exporting bills: $e");
      Fluttertoast.showToast(
        msg: "Error exporting bills: ${e.toString()}",
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}
