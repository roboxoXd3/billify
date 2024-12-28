import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:billify/model/product_model.dart';

class PdfService {
  Future<void> generateAndPrintBill(ProductResponse billData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text('Bill Detail',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),

              // Bill Number
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Bill Number:'),
                  pw.Text(billData.customerDetails?.billNumber ?? ''),
                ],
              ),
              pw.SizedBox(height: 20),

              // Customer Details
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Customer Details',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Name:'),
                        pw.Text(billData.customerDetails?.name ?? ''),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Phone:'),
                        pw.Text(billData.customerDetails?.phoneNumber ?? ''),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Location:'),
                        pw.Text(billData.customerDetails?.location ?? ''),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Items
              pw.Text('Items',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...billData.productData
                      ?.map((item) => pw.Container(
                            margin: const pw.EdgeInsets.symmetric(vertical: 5),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(item.productName ?? ''),
                                pw.Text('Discount: ${item.discount ?? "0"}%'),
                                pw.Text('Total: ${item.totalAmount ?? ""}'),
                              ],
                            ),
                          ))
                      .toList() ??
                  [],
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
