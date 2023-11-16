import 'package:u_traffic_enforcer/config/utils/exports.dart';

class Enforcer {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String photoUrl;
  final EmployeeStatus status;

  const Enforcer({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.photoUrl,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "email": email,
      "photoUrl": photoUrl,
      "status": EmployeeStatus.values.firstWhere(
          (element) => element.toString().contains(status.toString())),
    };
  }

  factory Enforcer.fromJson(Map<String, dynamic> json, String id) {
    return Enforcer(
      id: id,
      firstName: json["firstName"],
      middleName: json["middleName"],
      lastName: json["lastName"],
      email: json['email'],
      photoUrl: json['photoUrl'],
      status: EmployeeStatus.values
          .firstWhere((element) => element.toString().contains(json['status'])),
    );
  }

  @override
  String toString() {
    return "Enforcer(id: $id, firstName: $firstName, middleName: $middleName, lastName: $lastName)";
  }
}
