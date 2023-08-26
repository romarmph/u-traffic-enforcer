class Enforcer {
  final String? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String profileImageUrl;
  final String email;

  const Enforcer({
    this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.profileImageUrl,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "profileImageUrl": profileImageUrl,
      "email": email,
    };
  }

  factory Enforcer.fromJson(Map<String, dynamic> json) {
    return Enforcer(
      id: json["id"],
      firstName: json["firstName"],
      middleName: json["middleName"],
      lastName: json["lastName"],
      profileImageUrl: json["profileImageUrl"],
      email: json['email'],
    );
  }

  @override
  String toString() {
    return "Enforcer(id: $id, firstName: $firstName, middleName: $middleName, lastName: $lastName, profileImageUrl: $profileImageUrl)";
  }
}
