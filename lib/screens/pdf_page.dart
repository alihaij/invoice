import 'package:flutter/material.dart';
import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/buyer.dart';
import '../model/invoice.dart';
import '../model/seller.dart';
import '../components/button_widget.dart';
import '../components/title_widget.dart';
import 'package:invoice/components/custom_button.dart';

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
                CustomButton(
                  text: 'Invoice PDF',
                  onPressed: () async {
                    final date = DateTime.now();

                    final invoice = Invoice(
                      supplier: Seller(
                        name: 'Derwazah',
                        address:
                            'Al Ned Street, Al Zahra, Jeddah 21435, Saudi Arabia',
                        vatRegistrationNum: 'VAT Number: 310428871100003',
                        webSite: 'https://www.derwaza.tech/',
                      ),
                      customer: Buyer(
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
                          unitPrice: 15,
                          quantity: 3,
                        ),
                        InvoiceItem(
                          description: 'Water',
                          unitPrice: 2,
                          quantity: 2,
                        ),
                        InvoiceItem(
                          description: 'Cookies',
                          unitPrice: 5,
                          quantity: 2,
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
