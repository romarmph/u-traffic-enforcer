class QRDetails {
  final String licenseNumber;
  final String driverName;
  final String birthDate;
  final String address;
  final String? email;
  final String? phone;
  final String uid;

  const QRDetails({
    required this.licenseNumber,
    required this.driverName,
    required this.birthDate,
    required this.address,
    required this.email,
    required this.phone,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      "licenseNumber": licenseNumber,
      "driverName": driverName,
      "birthDate": birthDate,
      "address": address,
      "email": email,
      "phone": phone,
      "uid": uid,
    };
  }

  factory QRDetails.fromJson(Map<String, dynamic> json) {
    return QRDetails(
      licenseNumber: json["licenseNumber"],
      driverName: json["driverName"],
      birthDate: json["birthDate"],
      address: json["address"],
      email: json["email"],
      phone: json["phone"],
      uid: json["uid"],
    );
  }
}
