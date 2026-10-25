import 'package:prestacash/core/enum/LoanStatus.dart';
import 'package:prestacash/models/customer.dart';

class Loan {
  final int id;
  final double amount;
  final double interest;
  final bool interestApplications;
  final String loanDate;
  final int plazo;
  final LoanStatus status;
  final Customer? customer;
  final int? customerId;

  Loan({
    required this.id,
    required this.amount,
    required this.interest,
    required this.interestApplications,
    required this.loanDate,
    required this.plazo,
    required this.status,
    this.customer,
    this.customerId,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json['id'],
        amount: (json['amount'] as num).toDouble(),
        interest: (json['interest'] as num).toDouble(),
        interestApplications: json['interestApplications'] ?? false,
        loanDate: json['loanDate'] ?? '',
        plazo: json['plazo'] ?? 0,
        status: LoanStatus.fromJson(json['status']),
        customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
        customerId: json['customerId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'interest': interest,
        'interestApplications': interestApplications,
        'loanDate': loanDate,
        'plazo': plazo,
        'status': status.toString().split('.').last,
        'customer': customer?.toJson(),
        'customerId': customerId,
      };

  String toString() {
    return 'Loan{id: $id, amount: $amount, interest: $interest, interestApplications: $interestApplications, loanDate: $loanDate, plazo: $plazo, status: $status, customer: ${customer.toString()}, customerId: $customerId}';
  }
}
