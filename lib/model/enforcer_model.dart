class Enforcer {
  final String? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String? suffix;
  final String profileImageUrl;

  const Enforcer({
    this.id,
    this.suffix,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "suffix": suffix,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "profileImageUrl": profileImageUrl,
    };
  }

  factory Enforcer.fromJson(Map<String, dynamic> json) {
    return Enforcer(
      id: json["id"],
      suffix: json["suffix"],
      firstName: json["firstName"],
      middleName: json["middleName"],
      lastName: json["lastName"],
      profileImageUrl: json["profileImageUrl"],
    );
  }

  @override
  String toString() {
    return "Enforcer(id: $id, suffix: $suffix, firstName: $firstName, middleName: $middleName, lastName: $lastName, profileImageUrl: $profileImageUrl)";
  }
}
