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
  final DateTime? expirationdate;
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

  @override
  String toString() {
    return 'License Number: $licensenumber\n'
        'First Name: $firstName\n'
        'Middle Name: $middleName\n'
        'Last Name: $lastName\n'
        'Suffix: $suffix\n'
        'Sex: $sex\n'
        'Birthdate: ${birthdate?.toIso8601String()}\n'
        'Nationality: $nationality\n'
        'Address: $address\n'
        'Agency Code: $agencycode\n'
        'Height: ${height?.toStringAsFixed(2)}\n'
        'Weight: ${weight?.toStringAsFixed(2)}\n'
        'DL Codes: $dlcodes\n'
        'Blood Type: $bloodtype\n'
        'Expiration Date: $expirationdate\n'
        'Condition: $condition\n'
        'License Image URL: $licenseImageUrl';
  }
}
