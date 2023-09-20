class Enforcer {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;

  const Enforcer({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "email": email,
    };
  }

  factory Enforcer.fromJson(Map<String, dynamic> json, String id) {
    return Enforcer(
      id: id,
      firstName: json["firstName"],
      middleName: json["middleName"],
      lastName: json["lastName"],
      email: json['email'],
    );
  }

  @override
  String toString() {
    return "Enforcer(id: $id, firstName: $firstName, middleName: $middleName, lastName: $lastName)";
  }
}
