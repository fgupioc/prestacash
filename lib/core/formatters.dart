// lib/core/formatters.dart
import 'package:intl/intl.dart';

final currencyFormat = NumberFormat('#,##0.00', 'en_US');
final currencyFormatWithSymbol = NumberFormat.currency(
  locale: 'en_US',
  symbol: 'S/ ',
  decimalDigits: 2,
);