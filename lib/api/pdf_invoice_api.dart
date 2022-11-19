import 'dart:io';
// import 'package:printing/printing.dart';
import 'package:printing/printing.dart';

import '../api/pdf_api.dart';
import '../model/buyer.dart';
import '../model/invoice.dart';
import '../model/seller.dart';
import '../utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final netImage =
        await networkImage('https://derwaza.tech/imgs/derwaza-logo.png');

    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        Image(netImage, height: 100, width: 100),
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(
        name: '${DateTime.now().microsecondsSinceEpoch}.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // buildLogo(),
              buildSupplierAddress(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.toString(),
                ),
              ),
              // pw.Image(pw.MemoryImage(
              // (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
              // )),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Buyer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
    ];
    final data = <String>[
      info.serialNumber,
      Utils.formatDate(info.date),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  // static Future<pw.Widget> buildLogo() async {
  //   final netImage =
  //       await networkImage("https://derwaza.tech/imgs/derwaza-logo.png%27");
  //   ;

  //   return Container(child: pw.Image(netImage));
  // }

  static Widget buildSupplierAddress(Seller supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // pw.Image(pw.MemoryImage(
          //   File('images/logo.png').readAsBytesSync(),
          // )),
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
          Text(supplier.vatRegistrationNum),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Description',
      'Unit Price',
      'Quantity',
      'Total Excl. VAT',
      'VAT Rate',
      'VAT Amount',
      'Total Price'
    ];
    final data = invoice.items.map((item) {
      final totalExVat = item.unitPrice * item.quantity;
      final vatAmount = totalExVat * item.vat;
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        '${item.unitPrice} SAR',
        '${item.quantity}',
        '${totalExVat} SAR',
        '${(item.vat * 100).toInt()}%',
        '${vatAmount.toStringAsFixed(2)}',
        '${total.toStringAsFixed(2)} SAR',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
        6: Alignment.center,
        7: Alignment.center,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Total Excl. Vat',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'Vat ${(vatPercent * 100).toInt()} %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total Inc. Vat',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Website', value: invoice.supplier.webSite),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
