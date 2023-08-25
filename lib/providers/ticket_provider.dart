import 'package:flutter/material.dart';
import 'package:u_traffic_enforcer/model/ticket_model.dart';

import '../config/enums/ticket_status.dart';

class TicketProvider extends ChangeNotifier {
  Ticket _ticket = Ticket(
    ticketNumber: null,
    violationsID: {},
    licenseNumber: "",
    firstName: "",
    middleName: "",
    lastName: "",
    birthDate: null,
    address: "",
    status: TicketStatus.unpaid,
    vehicleType: "",
    engineNumber: "",
    chassisNumber: "",
    plateNumber: "",
    vehicleOwner: "",
    vehicleOwnerAddress: "",
    placeOfViolation: "",
    violationDateTime: null,
    enforcerId: "",
    driverSignature: "",
    licenseImageUrl: "",
  );

  Ticket get getTicket => _ticket;

  void updateTicket(Ticket ticket) {
    _ticket = ticket;
    notifyListeners();
  }
}
