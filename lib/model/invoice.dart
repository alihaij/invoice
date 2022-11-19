import '../model/customer.dart';
import '../model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final DateTime date;
  final String serialNumber;
  final double totalPrice;
  final double vatRate;
  final double vatAmmount;

  const InvoiceInfo({
    required this.serialNumber,
    required this.totalPrice,
    required this.vatRate,
    required this.vatAmmount,
    required this.description,
    required this.date,
  });

  @override
  String toString() {
    return 'Serial Number: $serialNumber , Total Price: $totalPrice SAR , Vat Rate: $vatRate % , Vat Amount:  $vatAmmount SAR';
  }
}

class InvoiceItem {
  final String description;
  final double unitPrice;
  final int quantity;
  final double TotalExcludingVAT;
  final double vat;
  final double vatAmount;

  const InvoiceItem({
    required this.description,
    required this.unitPrice,
    required this.quantity,
    required this.TotalExcludingVAT,
    required this.vat,
    required this.vatAmount,
  });
}
