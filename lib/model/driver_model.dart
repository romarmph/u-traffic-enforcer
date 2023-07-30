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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "suffix": suffix,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "birthDate": birthDate,
      "email": email,
      "phone": phone,
    };
  }

  // Create fromJson method
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json["id"],
      suffix: json["suffix"],
      firstName: json["firstName"],
      middleName: json["middleName"],
      lastName: json["lastName"],
      birthDate: json["birthDate"],
      email: json["email"],
      phone: json["phone"],
    );
  }

  // Create toString method
  @override
  String toString() {
    return "Driver(id: $id, suffix: $suffix, firstName: $firstName, middleName: $middleName, lastName: $lastName, birthDate: $birthDate, email: $email, phone: $phone)";
  }
}
