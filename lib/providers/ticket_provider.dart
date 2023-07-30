import 'package:flutter/material.dart';
import 'package:u_traffic_enforcer/model/ticket_model.dart';

import '../config/enums/ticket_status.dart';

class TicketProvider extends ChangeNotifier {
  Ticket _ticket = Ticket(
    ticketNumber: 0,
    violationsID: [],
    licenseNumber: "",
    driverFirstName: "",
    driverMiddleName: "",
    driverLastName: "",
    birthDate: DateTime.now(),
    address: "",
    status: TicketStatus.unpaid,
    vehicleType: "",
    engineNumber: "",
    chassisNumber: "",
    plateNumber: "",
    vehicleOwner: "",
    vehicleOwnerAddress: "",
    placeOfViolation: "",
    violationDateTime: "",
    enforcerId: "",
    driverSignature: "",
  );

  Ticket get getTicket => _ticket;

  void updateTicket(String fieldName, dynamic value) {
    Map<String, dynamic> ticket = _ticket.toJson();
    ticket[fieldName] = value;
    _ticket = Ticket.fromJson(ticket);
    notifyListeners();
  }
}
