import 'package:prestacash/models/loan.dart';

import '../core/enum/LoanStatus.dart';

class Cuota {
  final int id;
  final int cuota;
  final double amount;
  final String dueDate;
  final LoanStatus status;
  final Loan loan;

  Cuota({
    required this.id,
    required this.cuota,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.loan,
  });

  factory Cuota.fromJson(Map<String, dynamic> json) => Cuota(
    id: json['id'],
    cuota: json['cuota'],
    amount: (json['amount'] as num).toDouble(),
    dueDate: json['dueDate'] ?? '',
    status: LoanStatus.fromJson(json['status']),
    loan: Loan.fromJson(json['loan']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'cuota': cuota,
    'amount': amount,
    'dueDate': dueDate,
    'status': status.toString().split('.').last,
    'loan': loan.toJson(),
  };

  String toString() {
    return 'Cuota{id: $id, cuota: $cuota, amount: $amount, dueDate: $dueDate, status: $status, loan: ${loan.toString()}}';
  }
}
