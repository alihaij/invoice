import 'package:flutter/material.dart';
import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../widget/button_widget.dart';
import '../widget/title_widget.dart';

class PdfPage extends StatefulWidget {
  static const String id = "pdf_page";
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Invoice'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleWidget(
                  icon: Icons.picture_as_pdf,
                  text: 'Generate Invoice',
                ),
                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Invoice PDF',
                  onClicked: () async {
                    final date = DateTime.now();

                    final invoice = Invoice(
                      supplier: Supplier(
                        name: 'Derwazah',
                        address:
                            'Al Ned Street, Al Zahra, Jeddah 21435, Saudi Arabia',
                        webSite: 'https://www.derwaza.tech/',
                      ),
                      customer: Customer(
                        name: 'Buyer Name: Ali',
                      ),
                      info: InvoiceInfo(
                        date: date,
                        totalPrice: 0,
                        vatAmmount: 0,
                        vatRate: 0,
                        description: 'My description...',
                        serialNumber:
                            '${DateTime.now().millisecondsSinceEpoch}',
                      ),
                      items: [
                        InvoiceItem(
                          description: 'Coffee',
                          unitPrice: 0.99,
                          quantity: 8,
                          TotalExcludingVAT: 15,
                          vat: 0.19,
                          vatAmount: 10,
                        ),
                        InvoiceItem(
                          description: 'Water',
                          unitPrice: 0.99,
                          quantity: 8,
                          TotalExcludingVAT: 15,
                          vat: 0.19,
                          vatAmount: 10,
                        ),
                        InvoiceItem(
                          description: 'Apple',
                          unitPrice: 0.99,
                          quantity: 8,
                          TotalExcludingVAT: 15,
                          vat: 0.19,
                          vatAmount: 10,
                        ),
                      ],
                    );

                    final pdfFile = await PdfInvoiceApi.generate(invoice);

                    PdfApi.openFile(pdfFile);
                    PdfApi.uploadFile(pdfFile.path.split('/').last, pdfFile);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
