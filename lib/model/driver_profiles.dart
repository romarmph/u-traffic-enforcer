import 'package:u_traffic_enforcer/config/utils/exports.dart';

class DriverProfiles {
  final String? id;
  final String? licenseNumber;
  final String? driverName;
  final String? phone;
  final String? email;
  final String? address;
  final String enforcerId;
  final Timestamp? birthDate;
  final Timestamp createdAt;

  const DriverProfiles({
    this.id,
    required this.licenseNumber,
    required this.driverName,
    required this.phone,
    required this.email,
    required this.address,
    required this.enforcerId,
    required this.birthDate,
    required this.createdAt,
  });

  factory DriverProfiles.fromJson(Map<String, dynamic> json, [String? id]) {
    return DriverProfiles(
      id: id,
      licenseNumber: json['licenseNumber'] as String?,
      driverName: json['driverName'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      enforcerId: json['enforcerId'] as String,
      birthDate: json['birthDate'] as Timestamp?,
      createdAt: json['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licenseNumber': licenseNumber,
      'driverName': driverName,
      'phone': phone,
      'email': email,
      'address': address,
      'enforcerId': enforcerId,
      'birthDate': birthDate,
      'createdAt': createdAt,
    };
  }

  DriverProfiles copyWith({
    String? id,
    String? licenseNumber,
    String? driverName,
    String? phone,
    String? email,
    String? address,
    String? enforcerId,
    Timestamp? birthDate,
    Timestamp? createdAt,
  }) {
    return DriverProfiles(
      id: id ?? this.id,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      driverName: driverName ?? this.driverName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      enforcerId: enforcerId ?? this.enforcerId,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
