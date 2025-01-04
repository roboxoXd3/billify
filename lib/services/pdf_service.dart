import 'dart:io';

import 'package:billify/storage_/StorageUtil.dart';
import 'package:billify/storage_/storage_const.dart';
import 'package:ext_plus/ext_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:billify/model/product_model.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfService {
  Future<void> generateAndPrintBill(ProductResponse billData) async {
    bool isOpticalTemplate = false;
    String companyName = '';
    String address = '';
    String phone = '';
    String email = '';
    String gst = '';

    var profileData = StorageUtil.getObject(userData);
    if (profileData.isNotEmpty) {
      var data = jsonDecode(profileData);
      companyName = data['businessName'] ?? '';
      address = data['address'] ?? '';
      phone = data['phone'] ?? '';
      email = data['email'] ?? '';
      gst = data['gstNumber'] ?? '';
      String template = data['selectedTemplateType'];
      isOpticalTemplate = template == "2";
    }

    // Debug prints
    print('Template Type: ${isOpticalTemplate ? "Optical" : "Default"}');
    print('Product Data: ${billData.productData?.length} items');
    print('Customer Details: ${billData.customerDetails?.toJson()}');
    print('Prescription Details: ${billData.prescriptionDetails?.toJson()}');

    final pdf = pw.Document();

    // Modify the items section to ensure it's rendering
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with business details
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(companyName,
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    if (address.isNotEmpty) ...[
                      pw.SizedBox(height: 5),
                      pw.Text(address),
                    ],
                    if (phone.isNotEmpty) pw.Text('Phone: $phone'),
                    if (email.isNotEmpty) pw.Text('Email: $email'),
                    if (gst.isNotEmpty) pw.Text('GST: $gst'),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Bill details with date
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      'Bill Number: ${billData.customerDetails?.billNumber ?? ''}'),
                  pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}'),
                ],
              ),

              // ... existing customer details section ...

              // Items section with debug text
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        'Items (${billData.productData?.length ?? 0} items)',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),

                    // Always show what template we're using
                    pw.Text(
                        'Template: ${isOpticalTemplate ? "Optical" : "Default"}'),
                    pw.SizedBox(height: 10),

                    if (isOpticalTemplate) ...[
                      // Optical template header
                      pw.Row(
                        children: [
                          pw.Expanded(flex: 2, child: pw.Text('Frame')),
                          pw.Expanded(child: pw.Text('Price')),
                          pw.Expanded(flex: 2, child: pw.Text('Lens')),
                          pw.Expanded(child: pw.Text('Price')),
                          pw.Expanded(child: pw.Text('Total')),
                        ],
                      ),
                      pw.Divider(),
                      ...billData.productData
                              ?.map(
                                (item) => pw.Row(
                                  children: [
                                    pw.Expanded(
                                        flex: 2,
                                        child:
                                            pw.Text(item.productName ?? '-')),
                                    pw.Expanded(
                                        child: pw.Text(item.framePrice ?? '0')),
                                    pw.Expanded(
                                        flex: 2,
                                        child: pw.Text(item.lensName ?? '-')),
                                    pw.Expanded(
                                        child: pw.Text(item.lensPrice ?? '0')),
                                    pw.Expanded(
                                        child:
                                            pw.Text(item.totalAmount ?? '0')),
                                  ],
                                ),
                              )
                              .toList() ??
                          [pw.Text('No items')],
                    ] else ...[
                      // Default template
                      pw.Row(
                        children: [
                          pw.Expanded(flex: 3, child: pw.Text('Product')),
                          pw.Expanded(child: pw.Text('Qty')),
                          pw.Expanded(child: pw.Text('Total')),
                        ],
                      ),
                      pw.Divider(),
                      ...billData.productData
                              ?.map(
                                (item) => pw.Row(
                                  children: [
                                    pw.Expanded(
                                        flex: 3,
                                        child:
                                            pw.Text(item.productName ?? '-')),
                                    pw.Expanded(
                                        child: pw.Text(item.qty ?? '1')),
                                    pw.Expanded(
                                        child:
                                            pw.Text(item.totalAmount ?? '0')),
                                  ],
                                ),
                              )
                              .toList() ??
                          [pw.Text('No items')],
                    ],
                  ],
                ),
              ),

              // Prescription details for optical template
              if (isOpticalTemplate &&
                  billData.prescriptionDetails != null) ...[
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Prescription Details',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      _buildPrescriptionTable(billData),
                    ],
                  ),
                ),
              ],

              // Grand Total
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Grand Total:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(billData.customerDetails?.grandTotal ?? '0'),
                  ],
                ),
              ),

              // Footer
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 20),
                alignment: pw.Alignment.center,
                child: pw.Column(
                  children: [
                    pw.Text('Thank you for your business!',
                        style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                    if (phone.isNotEmpty)
                      pw.Text('For any queries, please contact: $phone'),
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

  // Helper method for prescription table
  pw.Widget _buildPrescriptionTable(ProductResponse billData) {
    final prescriptionDetails = billData.prescriptionDetails;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // SPH/CYL/AXIS Table
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(''),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('SPH'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('CYL'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('AXIS'),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('R'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child:
                      pw.Text(prescriptionDetails?.rightSph?.toString() ?? '-'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child:
                      pw.Text(prescriptionDetails?.rightCyl?.toString() ?? '-'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                      prescriptionDetails?.rightAxis?.toString() ?? '-'),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('L'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child:
                      pw.Text(prescriptionDetails?.leftSph?.toString() ?? '-'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child:
                      pw.Text(prescriptionDetails?.leftCyl?.toString() ?? '-'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child:
                      pw.Text(prescriptionDetails?.leftAxis?.toString() ?? '-'),
                ),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 10),

        // Power and Visual Details
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(''),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Power'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Visual'),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('R'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                      prescriptionDetails?.rightPower?.toString() ?? '-'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                      prescriptionDetails?.rightVisual?.toString() ?? '-'),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('L'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                      prescriptionDetails?.leftPower?.toString() ?? '-'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                      prescriptionDetails?.leftVisual?.toString() ?? '-'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> generateAndShareBill(ProductResponse billData) async {
    print('Starting PDF generation...');
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

    print('Creating PDF content...');
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
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('Product Name:',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                          pw.Text(item.productName.validate(),
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
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
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                          pw.Text(
                                              isOpticalTemplate
                                                  ? item.framePrice
                                                      .validate(value: '0')
                                                  : item.qty
                                                      .validate(value: '1'),
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ],
                                      ),
                                      pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text("Discount:",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                          pw.Text(
                                              '${item.discount.validate(value: "0")}%',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ],
                                      ),
                                      pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('Total:',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                          pw.Text(
                                              item.totalAmount
                                                  .validate(value: "0"),
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.normal)),
                                        ],
                                      ),
                                    ],
                                  ))
                              .toList() ??
                          [],
                    ],
                  )),
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

    print('Saving PDF...');
    final output = await getTemporaryDirectory();
    final file =
        File('${output.path}/Bill_${billData.customerDetails?.billNumber}.pdf');
    await file.writeAsBytes(await pdf.save());

    print('Sharing PDF...');
    await Share.shareXFiles([XFile(file.path)],
        subject: 'Bill ${billData.customerDetails?.billNumber}');
    print('PDF shared successfully!');

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
