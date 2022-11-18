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
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });
}
