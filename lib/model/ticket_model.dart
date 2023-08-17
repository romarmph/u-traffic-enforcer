import 'package:u_traffic_enforcer/config/enums/ticket_status.dart';

class Ticket {
  final String? id;
  int? ticketNumber;
  List<String?> violationsID;
  String? licenseNumber;
  String? driverFirstName;
  String? driverMiddleName;
  String? driverLastName;
  DateTime? birthDate;
  String? address;
  TicketStatus? status;
  String? vehicleType;
  String? engineNumber;
  String? chassisNumber;
  String? plateNumber;
  String? vehicleOwner;
  String? vehicleOwnerAddress;
  String? placeOfViolation;
  String? violationDateTime;
  String? enforcerId;
  String? driverSignature;
  String? licenseImageUrl;

  Ticket({
    this.id,
    this.ticketNumber,
    this.violationsID = const [],
    this.licenseNumber,
    this.driverFirstName,
    this.driverMiddleName,
    this.driverLastName,
    this.birthDate,
    this.address,
    this.status,
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
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      ticketNumber: json['ticketNumber'],
      violationsID: json['violationsID'],
      licenseNumber: json['licenseNumber'],
      driverFirstName: json['driverFirstName'],
      driverMiddleName: json['driverMiddleName'],
      driverLastName: json['driverLastName'],
      birthDate: json['birthDate'],
      address: json['address'],
      status: json['status'],
      vehicleType: json['vehicleType'],
      engineNumber: json['engineNumber'],
      chassisNumber: json['chassisNumber'],
      plateNumber: json['plateNumber'],
      vehicleOwner: json['vehicleOwner'],
      vehicleOwnerAddress: json['vehicleOwnerAddress'],
      placeOfViolation: json['placeOfViolation'],
      violationDateTime: json['violationDateTime'],
      enforcerId: json['enforcerId'],
      driverSignature: json['driverSignature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketNumber': ticketNumber,
      'violationsID': violationsID,
      'licenseNumber': licenseNumber,
      'driverFirstName': driverFirstName,
      'driverMiddleName': driverMiddleName,
      'driverLastName': driverLastName,
      'birthDate': birthDate,
      'address': address,
      'status': status,
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
    };
  }

  @override
  String toString() {
    return "Ticket: ${toJson().toString()}";
  }

  dynamic operator [](String key) => toJson()[key];
}
