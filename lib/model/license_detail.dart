class LicenseDetail {
  // final String? id;
  // Might use license number as id
  final String? licenseNumber;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? suffix;
  final String? sex;
  final DateTime? birthDate;
  final String? nationality;
  final String? address;
  final String? agencyCode;
  final double? height;
  final double? weight;
  final String? restrictionCode;
  final String? bloodType;
  final String? issueDate;
  final String? expiryDate;
  final String? licenseType;
  final String? condition;
  final String? licenseImageUrl;

  LicenseDetail({
    this.licenseNumber,
    this.firstName,
    this.middleName,
    this.lastName,
    this.suffix,
    this.sex,
    this.birthDate,
    this.nationality,
    this.address,
    this.agencyCode,
    this.height,
    this.weight,
    this.restrictionCode,
    this.bloodType,
    this.issueDate,
    this.expiryDate,
    this.licenseType,
    this.condition,
    this.licenseImageUrl,
  });
}
