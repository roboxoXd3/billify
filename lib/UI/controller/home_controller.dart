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
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/inventory/services/database_helper.dart';

class HomeController extends GetxController {
  List<ProductResponse> dashboardData = [];
  List<ProductResponse> filteredData = [];
  bool isOpticalTemplate = false;
  TextEditingController searchController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

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
    loadBills();
    super.onInit();
  }

  Future<void> loadBills() async {
    try {
      final bills = await DatabaseHelper.instance.getAllBills();
      dashboardData = [];

      for (var bill in bills) {
        final items = await DatabaseHelper.instance.getBillItems(bill['id']);
        // Filter out any empty items
        final validItems = items
            .where((item) =>
                item['productName']?.isNotEmpty == true &&
                item['quantity'] != null &&
                item['quantity'] != 0)
            .toList();

        if (validItems.isNotEmpty) {
          // Only add bills with valid items
          dashboardData.add(ProductResponse(
            customerDetails: CustomerDetails(
              billNumber: bill['billNumber'],
              name: bill['customerName'],
              age: bill['customerAge'],
              phoneNumber: bill['customerPhone'],
              location: bill['customerLocation'],
              grandTotal: bill['grandTotal'],
              createdAt: bill['createdAt'],
            ),
            productData: validItems
                .map((item) => ProductData(
                      productName: item['productName'],
                      qty: item['quantity'].toString(),
                      amount: item['amount'].toString(),
                      totalAmount: item['totalAmount'].toString(),
                    ))
                .toList(),
          ));
        }
      }

      filteredData = List.from(dashboardData);
      update();
    } catch (e) {
      print('Error loading bills: $e');
    }
  }

  Future<void> exportMonthlyBills(
      BuildContext context, List<ProductResponse> bills) async {
    try {
      // Check Android version
      if (Platform.isAndroid) {
        if (await Permission.manageExternalStorage.request().isGranted) {
          await Permission.manageExternalStorage.request();
        } else {
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
      Directory? directory;

      if (Platform.isAndroid) {
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
        directory = await getApplicationDocumentsDirectory();
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

  void searchBills(String query) {
    if (query.isEmpty) {
      filteredData = List.from(dashboardData);
    } else {
      filteredData = dashboardData.where((bill) {
        final name = bill.customerDetails?.name?.toLowerCase() ?? '';
        final billNumber =
            bill.customerDetails?.billNumber?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || billNumber.contains(searchLower);
      }).toList();
    }
    update();
  }

  void deleteBill(int index) {
    // Get the bill before removing it
    final billToDelete = filteredData[index];

    // Remove from both lists
    filteredData.removeAt(index);
    dashboardData.removeWhere((bill) =>
        bill.customerDetails?.billNumber ==
        billToDelete.customerDetails?.billNumber);

    // Update storage
    String updatedDataJson = json.encode(dashboardData);
    StorageUtil.putString(dashBoardItem, updatedDataJson);

    // Force UI update
    update();

    // Refresh the filtered data
    if (searchController.text.isNotEmpty) {
      searchBills(searchController.text);
    }
  }

  double getTotalSales() {
    return dashboardData.fold(
        0.0,
        (sum, bill) =>
            sum +
            (double.tryParse(bill.customerDetails?.grandTotal ?? '0') ?? 0));
  }

  int getTotalBills() {
    return dashboardData.length;
  }

  double getCurrentMonthSales() {
    final now = DateTime.now();
    return dashboardData.where((bill) {
      final billDate =
          DateFormat('dd/MM/yyyy').parse(bill.customerDetails?.createdAt ?? '');
      return billDate.month == now.month && billDate.year == now.year;
    }).fold(
        0.0,
        (sum, bill) =>
            sum +
            (double.tryParse(bill.customerDetails?.grandTotal ?? '0') ?? 0));
  }

  double getTodaySales() {
    final now = DateTime.now();
    return dashboardData.where((bill) {
      final billDate =
          DateFormat('dd/MM/yyyy').parse(bill.customerDetails?.createdAt ?? '');
      return billDate.day == now.day &&
          billDate.month == now.month &&
          billDate.year == now.year;
    }).fold(
        0.0,
        (sum, bill) =>
            sum +
            (double.tryParse(bill.customerDetails?.grandTotal ?? '0') ?? 0));
  }

  void filterBillsByDate(DateTime? start, DateTime? end) {
    selectedStartDate = start;
    selectedEndDate = end;

    if (start == null && end == null) {
      filteredData = List.from(dashboardData);
    } else {
      filteredData = dashboardData.where((bill) {
        final billDate = DateFormat('dd/MM/yyyy')
            .parse(bill.customerDetails?.createdAt ?? '');
        if (start != null && end != null) {
          return billDate.isAfter(start.subtract(const Duration(days: 1))) &&
              billDate.isBefore(end.add(const Duration(days: 1)));
        } else if (start != null) {
          return billDate.isAfter(start.subtract(const Duration(days: 1)));
        } else if (end != null) {
          return billDate.isBefore(end.add(const Duration(days: 1)));
        }
        return true;
      }).toList();
    }
    update();
  }

  void clearDateFilter() {
    selectedStartDate = null;
    selectedEndDate = null;
    filteredData = List.from(dashboardData);
    update();
  }

  Future<void> exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];

    // Add headers
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        TextCellValue('Bill Number');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
        TextCellValue('Customer Name');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
        TextCellValue('Phone Number');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
        TextCellValue('Total Amount');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value =
        TextCellValue('Date');

    // Add data
    for (var i = 0; i < filteredData.length; i++) {
      final bill = filteredData[i];
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
          .value = TextCellValue(bill.customerDetails?.billNumber ?? '');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
          .value = TextCellValue(bill.customerDetails?.name ?? '');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
          .value = TextCellValue(bill.customerDetails?.phoneNumber ?? '');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
          .value = TextCellValue(bill.customerDetails?.grandTotal ?? '0');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1))
          .value = TextCellValue(bill.customerDetails?.createdAt ?? '');
    }

    // Save file
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/bills_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(path);
    await file.writeAsBytes(excel.encode()!);

    // Share file
    await Share.shareXFiles([XFile(path)], subject: 'Bills Export');
  }
}
