class Address {
  final String barangay;
  final String city;
  final String province;
  final String? street;
  final String? number;

  const Address({
    required this.barangay,
    required this.city,
    required this.province,
    this.street,
    this.number,
  });

  @override
  String toString() {
    if (number!.isEmpty && street!.isEmpty) {
      return '$barangay, $city, $province';
    }
    if (street!.isEmpty) {
      return '$number, $barangay, $city, $province';
    }

    if (number!.isEmpty) {
      return '$street, $barangay, $city, $province';
    }

    return '$number $street, $barangay, $city, $province';
  }
}
