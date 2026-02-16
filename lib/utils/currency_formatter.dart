import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final indianRupee = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String format(num value) {
    return indianRupee.format(value);
  }
}