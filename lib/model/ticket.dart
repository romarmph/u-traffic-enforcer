import 'package:u_traffic_enforcer/config/enums/ticket_status.dart';

class Ticket {
  final String? id;

  // Added this temporary as I might use id as ticket number
  final int? ticketNumber;

  final List<int> violationsID;
  final int? licenseNumber;
  final String? driverFirstName;
  final String? driverMiddleName;
  final String? driverLastName;
  final DateTime? birthDate;
  final String? city;
  final String? barangay;
  final String? street;
  TicketStatus status;
  final String? vehicleType;
  final String? engineNumber;
  final String? chassisNumber;
  final String? plateNumber;
  final String? vehileOwner;
  final String? vehicleOwnerAddress;
  final String? placeOfViolation;
  final String? dateOfViolation;
  final String? timeOfViolation;
  final String? enforcerId;
  // URL
  final String? driverSignature;

  Ticket({
    required this.violationsID,
    this.id,
    this.ticketNumber,
    this.licenseNumber,
    this.driverFirstName,
    this.driverMiddleName,
    this.driverLastName,
    this.birthDate,
    this.city,
    this.barangay,
    this.street,
    this.status = TicketStatus.unpaid,
    this.vehicleType,
    this.engineNumber,
    this.chassisNumber,
    this.plateNumber,
    this.vehileOwner,
    this.vehicleOwnerAddress,
    this.placeOfViolation,
    this.dateOfViolation,
    this.timeOfViolation,
    this.enforcerId,
    this.driverSignature,
  });
}
