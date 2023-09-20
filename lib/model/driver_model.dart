import 'package:u_traffic_enforcer/config/utils/exports.dart';

class Driver {
  final String? id;
  final String driverName;
  final Timestamp birthDate;
  final String address;
  final String? email;
  final String? phone;

  const Driver({
    this.id,
    this.phone,
    this.email,
    required this.driverName,
    required this.birthDate,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'driverName': driverName,
      'birthDate': birthDate,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverName: json['driverName'],
      birthDate: json['birthDate'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  @override
  String toString() {
    return 'Driver{driverName: $driverName, birthDate: $birthDate, email: $email, phone: $phone, address: $address}';
  }

  Driver copyWith({
    String? id,
    String? driverName,
    Timestamp? birthDate,
    String? email,
    String? phone,
    String? address,
  }) {
    return Driver(
      id: id ?? this.id,
      driverName: driverName ?? this.driverName,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
