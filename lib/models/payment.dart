import '../core/enum/PaymentType.dart';

class Payment {
  final int? id;
  final int? loanId;
  final double amount;
  final String paymentDate;
  final String paymentType;
  final String observations;

  Payment({
    this.id,
    this.loanId,
    required this.amount,
    required this.paymentDate,
    required this.paymentType,
    required this.observations,
  });

  @override
  String toString() {
    return 'Payment(loanId: $loanId, amount: $amount, paymentDate: $paymentDate, paymentType: $paymentType, observations: $observations)';
  }

  static Payment fromJson(data) {
    return Payment(
      id: data['id'],
      amount: data['amount'],
      paymentDate: data['paymentDate'],
      paymentType: data['paymentType'],
      observations: data['observations'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loanId': loanId,
      'id': id,
      'amount': amount,
      'paymentDate': paymentDate,
      'paymentType': paymentType,
      'observations': observations,
    };
  }
}