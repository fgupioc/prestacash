enum PaymentType {
  CASH('Efectivo'),
  BANK_TRANSFER('Transferencia'),
  YAPE('Yape'),
  PLIN('Plin');

  const PaymentType(this.label);

  final String label;
}

void main() {
  print(PaymentType.YAPE.label); // Yape
}
