import 'package:u_traffic_enforcer/config/enums/ticket_status.dart';

class Ticket {
  String? id;

  int? ticketNumber;

  List<String>? violationsID;
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

  Ticket({
    this.id,
    required this.ticketNumber,
    required this.violationsID,
    required this.licenseNumber,
    required this.driverFirstName,
    required this.driverMiddleName,
    required this.driverLastName,
    required this.birthDate,
    required this.address,
    required this.status,
    required this.vehicleType,
    required this.engineNumber,
    required this.chassisNumber,
    required this.plateNumber,
    required this.vehicleOwner,
    required this.vehicleOwnerAddress,
    required this.placeOfViolation,
    required this.violationDateTime,
    required this.enforcerId,
    required this.driverSignature,
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
