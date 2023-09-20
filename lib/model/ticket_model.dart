import '../../../config/utils/exports.dart';

class Ticket {
  String? id;
  int? ticketNumber;
  final String licenseNumber;
  final String driverName;
  final String phone;
  final String email;
  final String address;
  final String vehicleType;
  final String engineNumber;
  final String chassisNumber;
  final String plateNumber;
  final String vehicleOwner;
  final String vehicleOwnerAddress;
  final String enforcerID;
  final String enforcerName;
  final Timestamp birthDate;
  final Timestamp dateCreated;
  final Timestamp ticketDueDate;
  final Timestamp violationDateTime;
  final List<String?> violationsID;
  final ULocation violationPlace;
  final TicketStatus status;

  Ticket({
    this.id,
    this.ticketNumber,
    required this.licenseNumber,
    required this.driverName,
    required this.phone,
    required this.email,
    required this.address,
    required this.vehicleType,
    required this.engineNumber,
    required this.chassisNumber,
    required this.plateNumber,
    required this.vehicleOwner,
    required this.vehicleOwnerAddress,
    required this.enforcerID,
    required this.enforcerName,
    required this.status,
    required this.birthDate,
    required this.dateCreated,
    required this.ticketDueDate,
    required this.violationDateTime,
    required this.violationPlace,
    required this.violationsID,
  });

  factory Ticket.fromJson(Map<String, dynamic> json, [String? id]) {
    return Ticket(
      id: id,
      ticketNumber: json['ticketNumber'],
      licenseNumber: json['licenseNumber'],
      driverName: json['driverName'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      vehicleType: json['vehicleType'],
      engineNumber: json['engineNumber'],
      chassisNumber: json['chassisNumber'],
      plateNumber: json['plateNumber'],
      vehicleOwner: json['vehicleOwner'],
      vehicleOwnerAddress: json['vehicleOwnerAddress'],
      enforcerID: json['enforcerID'],
      enforcerName: json['enforcerName'],
      status: TicketStatus.values.firstWhere(
        (e) => e.toString() == 'TicketStatus.${json['status']}',
      ),
      birthDate: json['birthDate'],
      dateCreated: json['dateCreated'],
      ticketDueDate: json['ticketDueDate'],
      violationDateTime: json['violationDateTime'],
      violationPlace: ULocation.fromJson(json['violationPlace']),
      violationsID: List<String?>.from(json['violationsID'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketNumber': ticketNumber,
      'licenseNumber': licenseNumber,
      'driverName': driverName,
      'phone': phone,
      'email': email,
      'address': address,
      'vehicleType': vehicleType,
      'engineNumber': engineNumber,
      'chassisNumber': chassisNumber,
      'plateNumber': plateNumber,
      'vehicleOwner': vehicleOwner,
      'vehicleOwnerAddress': vehicleOwnerAddress,
      'enforcerID': enforcerID,
      'enforcerName': enforcerName,
      'status': status.toString().split('.').last,
      'birthDate': birthDate,
      'dateCreated': dateCreated,
      'ticketDueDate': ticketDueDate,
      'violationDateTime': violationDateTime,
      'violationPlace': violationPlace.toJson(),
      'violationsID': violationsID,
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

  Ticket copyWith({
    String? id,
    int? ticketNumber,
    String? licenseNumber,
    String? driverName,
    String? phone,
    String? email,
    String? address,
    String? vehicleType,
    String? engineNumber,
    String? chassisNumber,
    String? plateNumber,
    String? vehicleOwner,
    String? vehicleOwnerAddress,
    String? enforcerID,
    String? enforcerName,
    TicketStatus? status,
    Timestamp? birthDate,
    Timestamp? dateCreated,
    Timestamp? ticketDueDate,
    Timestamp? violationDateTime,
    ULocation? violationPlace,
    List<String?>? violationsID,
  }) {
    return Ticket(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      driverName: driverName ?? this.driverName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      vehicleType: vehicleType ?? this.vehicleType,
      engineNumber: engineNumber ?? this.engineNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleOwner: vehicleOwner ?? this.vehicleOwner,
      vehicleOwnerAddress: vehicleOwnerAddress ?? this.vehicleOwnerAddress,
      enforcerID: enforcerID ?? this.enforcerID,
      enforcerName: enforcerName ?? this.enforcerName,
      status: status ?? this.status,
      birthDate: birthDate ?? this.birthDate,
      dateCreated: dateCreated ?? this.dateCreated,
      ticketDueDate: ticketDueDate ?? this.ticketDueDate,
      violationDateTime: violationDateTime ?? this.violationDateTime,
      violationPlace: violationPlace ?? this.violationPlace,
      violationsID: violationsID ?? this.violationsID,
    );
  }
}
