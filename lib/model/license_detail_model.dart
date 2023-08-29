class LicenseDetail {
  final String? licensenumber;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? suffix;
  final String? sex;
  final DateTime? birthdate;
  final String? nationality;
  final String? address;
  final String? agencycode;
  final double? height;
  final double? weight;
  final String? dlcodes;
  final String? bloodtype;
  final String? expirationdate;
  final String? condition;
  final String? licenseImageUrl;

  LicenseDetail({
    this.licensenumber,
    this.firstName,
    this.middleName,
    this.lastName,
    this.suffix,
    this.sex,
    this.birthdate,
    this.nationality,
    this.address,
    this.agencycode,
    this.height,
    this.weight,
    this.dlcodes,
    this.bloodtype,
    this.expirationdate,
    this.condition,
    this.licenseImageUrl,
  });

  factory LicenseDetail.fromJson(Map<String, dynamic> json) {
    return LicenseDetail(
      licensenumber: json['licensenumber'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      suffix: json['suffix'],
      sex: json['sex'],
      birthdate: json['birthdate'],
      nationality: json['nationality'],
      address: json['address'],
      agencycode: json['agencycode'],
      height: json['height'],
      weight: json['weight'],
      dlcodes: json['dlcodes'],
      bloodtype: json['bloodtype'],
      expirationdate: json['expirationdate'],
      condition: json['condition'],
      licenseImageUrl: json['licenseImageUrl'],
    );
  }
}
