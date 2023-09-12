import '../../../config/utils/exports.dart';

class Ticket {
  final String? id;
  int? ticketNumber;
  Set<String?>? violationsID;
  String? licenseNumber;
  String? firstName;
  String? middleName;
  String? lastName;
  DateTime? birthDate;
  String? phone;
  String? email;
  String? address;
  TicketStatus? status;
  String? vehicleType;
  String? engineNumber;
  String? chassisNumber;
  String? plateNumber;
  String? vehicleOwner;
  String? vehicleOwnerAddress;
  Map<String, dynamic>? placeOfViolation;
  DateTime? violationDateTime;
  String? enforcerId;
  String? driverSignature;
  String? licenseImageUrl;
  DateTime? dateCreated;

  Ticket({
    this.id,
    this.ticketNumber,
    this.violationsID,
    this.licenseNumber,
    this.firstName,
    this.middleName,
    this.lastName,
    this.birthDate,
    this.phone,
    this.email,
    this.address,
    this.status = TicketStatus.unpaid,
    this.vehicleType,
    this.engineNumber,
    this.chassisNumber,
    this.plateNumber,
    this.vehicleOwner,
    this.vehicleOwnerAddress,
    this.placeOfViolation,
    this.violationDateTime,
    this.enforcerId,
    this.driverSignature,
    this.licenseImageUrl,
    this.dateCreated,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    Timestamp? violationDateTime = json['violationDateTime'] is DateTime
        ? Timestamp.fromDate(json['violationDateTime'])
        : json['violationDateTime'];
    Timestamp? dateCreated = json['dateCreated'] is DateTime
        ? Timestamp.fromDate(json['dateCreated'])
        : json['dateCreated'];
    Timestamp? birthDate;
    if (json['birthDate'] is String) {
      DateTime dateTime = DateTime.parse(json['birthDate']);
      birthDate = Timestamp.fromDate(dateTime);
    } else if (json['birthDate'] is DateTime) {
      birthDate = Timestamp.fromDate(json['birthDate']);
    } else {
      birthDate = json['birthDate'];
    }

    TicketStatus status = TicketStatus.values.firstWhere(
      (e) => e.toString() == 'TicketStatus.${json['status']}',
      orElse: () => TicketStatus.unpaid, // replace with your default status
    );

    return Ticket(
      id: json['id'],
      ticketNumber: json['ticketNumber'],
      violationsID: json['violationsID'] != null
          ? Set<String>.from(json['violationsID'])
          : null,
      licenseNumber: json['licenseNumber'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      birthDate: birthDate!.toDate(),
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      status: status,
      vehicleType: json['vehicleType'],
      engineNumber: json['engineNumber'],
      chassisNumber: json['chassisNumber'],
      plateNumber: json['plateNumber'],
      vehicleOwner: json['vehicleOwner'],
      vehicleOwnerAddress: json['vehicleOwnerAddress'],
      placeOfViolation: json['placeOfViolation'],
      violationDateTime: violationDateTime!.toDate(),
      enforcerId: json['enforcerId'],
      driverSignature: json['driverSignature'],
      licenseImageUrl: json['licenseImageUrl'],
      dateCreated: dateCreated!.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketNumber': ticketNumber,
      'violationsID': violationsID!.toList(),
      'licenseNumber': licenseNumber,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'birthDate': birthDate,
      'phone': phone,
      'email': email,
      'address': address,
      'status': status.toString().split('.').last,
      'vehicleType': vehicleType,
      'engineNumber': engineNumber,
      'chassisNumber': chassisNumber,
      'plateNumber': plateNumber,
      'vehicleOwner': vehicleOwner,
      'vehicleOwnerAddress': vehicleOwnerAddress,
      'placeOfViolation': placeOfViolation,
      'violationDateTime': violationDateTime,
      'enforcerId': enforcerId,
      'driverSignature': driverSignature,
      'licenseImageUrl': licenseImageUrl,
      'dateCreated': dateCreated,
    };
  }

  @override
  String toString() {
    return "Ticket: ${toJson().toString()}";
  }

  dynamic operator [](String key) => toJson()[key];

  Map<String, dynamic> map(Function(String key, dynamic value) f) {
    Map<String, dynamic> result = {};

    toJson().forEach((key, value) {
      result.addAll(f(key, value));
    });

    return result;
  }
}
