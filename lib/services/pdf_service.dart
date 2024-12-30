import 'package:billify/storage_/StorageUtil.dart';
import 'package:billify/storage_/storage_const.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:billify/model/product_model.dart';
import 'dart:convert';

class PdfService {
  Future<void> generateAndPrintBill(ProductResponse billData) async {
    final pdf = pw.Document();
    bool isOpticalTemplate = false;
    var profileData = StorageUtil.getObject(userData);
    String companyName = '';
    if (profileData.isNotEmpty) {
      var data = jsonDecode(profileData);
      companyName = data['businessName'] ?? 'Company Name';
      String template = data['selectedTemplateType'];
      if (template == "1") {
        isOpticalTemplate = false;
      } else if (template == "2") {
        isOpticalTemplate = true;
      }
    }

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(companyName,
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Bill Number:'),
                  pw.Text(billData.customerDetails?.billNumber ?? '',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.circular(8)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Customer Details',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 6),
                   
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Name:',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                        pw.Text(billData.customerDetails?.name ?? '',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Phone:',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                        pw.Text(billData.customerDetails?.phoneNumber ?? '',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Location:',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                        pw.Text(billData.customerDetails?.location ?? '',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
            pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(),
                                borderRadius: pw.BorderRadius.circular(8)),
                            margin: const pw.EdgeInsets.symmetric(vertical: 5),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
              pw.Text('Items',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 6),
              ...billData.productData
                      ?.map((item) => pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('Product Name: :',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                    pw.Text(item.productName.validate(),
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                  ],
                                ),
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(
                                        isOpticalTemplate
                                            ? 'Frame Price:'
                                            : "Qty:",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                    pw.Text(
                                        isOpticalTemplate
                                            ? item.framePrice
                                                .validate(value: '0')
                                            : item.qty.validate(value: '1'),
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                  ],
                                ),
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text("Discount:",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                    pw.Text(
                                        '${item.discount.validate(value: "0")}%',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                  ],
                                ),
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('Total:',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                    pw.Text(
                                        item.totalAmount.validate(value: "0"),
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                  ],
                                ),
                              ],
                            ),
                      )
                      .toList() ??
                  [],
            ])),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF000000)),
                    borderRadius: pw.BorderRadius.circular(8)),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Grand Total:',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 16)),
                    pw.Text(billData.customerDetails?.grandTotal ?? '',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.normal)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
