// lib/core/formatters.dart
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

final currencyFormat = NumberFormat('#,##0.00', 'en_US');
final currencyFormatWithSymbol = NumberFormat.currency(
  locale: 'en_US',
  symbol: 'S/ ',
  decimalDigits: 2,
);

String? validateAmount(String? v) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return 'Ingrese un monto';

  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(t)) {
    return 'Monto inválido (ej: 1500 o 1500.50)';
  }

  final monto = double.tryParse(t);
  if (monto == null) return 'Monto inválido';
  if (monto <= 0) return 'El monto debe ser mayor a 0';

  const min = 1.0;
  const max = 100000.0;
  if (monto < min) return 'Monto mínimo: S/ ${min.toStringAsFixed(0)}';
  if (monto > max) return 'Monto máximo: S/ ${max.toStringAsFixed(0)}';

  return null;
}

String formatDate(String date) {
  final parts = date.split('/');
  if (parts.length != 3) {
    throw FormatException('Fecha inválida: $date');
  }

  final day = parts[0].padLeft(2, '0');
  final month = parts[1].padLeft(2, '0');
  final year = parts[2].padLeft(4, '0');

  return '$year-$month-$day';
}

String formatDate2(String date) {
  final parts = date.split('-');
  if (parts.length != 3) {
    throw FormatException('Fecha inválida: $date');
  }

  final year = parts[0].padLeft(4, '0');
  final month = parts[1].padLeft(2, '0');
  final day = parts[2].padLeft(2, '0');

  return '$day/$month/$year';
}