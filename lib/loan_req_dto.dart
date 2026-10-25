class LoanReqDto {
  final int customerId;
  final double amount;
  final bool aplicacionInterest;
  final double interest;
  final String initDate;
  final int plazo;

  LoanReqDto({
    required this.customerId,
    required this.amount,
    required this.aplicacionInterest,
    required this.interest,
    required this.initDate,
    required this.plazo,
  });

  @override
  String toString() {
    return 'LoanReqDto(customerId: $customerId, amount: $amount, aplicacionInterest: $aplicacionInterest, interest: $interest, initDate: $initDate, plazo: $plazo)';
  }
}