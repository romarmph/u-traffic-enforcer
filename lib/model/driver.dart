class Driver {
  final String? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String? suffix;
  final String birthDate;
  final String email;
  final String phone;

  const Driver({
    this.id,
    this.suffix,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthDate,
    required this.email,
    required this.phone,
  });
}
