class Customer {
  final int id;
  final String documentType;
  final String documentNumber;
  final String name;
  final String lastName;
  final String fullName;
  final String? phone;
  final String? address;

  Customer({
    required this.id,
    required this.documentType,
    required this.documentNumber,
    required this.name,
    required this.lastName,
    required this.fullName,
    this.phone,
    this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'],
    documentType: json['documentType'] ?? '',
    documentNumber: json['documentNumber'] ?? '',
    name: json['name'] ?? '',
    lastName: json['lastName'] ?? '',
    fullName: json['fullName'] ?? '',
    phone: json['phone'],
    address: json['address'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'documentType': documentType,
    'documentNumber': documentNumber,
    'name': name,
    'lastName': lastName,
    'phone': phone,
    'address': address,
  };
}