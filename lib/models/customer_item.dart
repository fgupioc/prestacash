class CustomerItem {
  final String fullName;
  final String phone;
  final int loansCount;

  CustomerItem({
    required this.fullName,
    required this.phone,
    required this.loansCount,
  });

  String get firstCharacter => fullName.isNotEmpty ? fullName[0].toUpperCase() : '';
}