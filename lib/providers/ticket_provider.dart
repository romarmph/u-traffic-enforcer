import '../../../config/utils/exports.dart';

class TicketProvider extends ChangeNotifier {
  Ticket _lastPrintedTicket = Ticket();

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
    placeOfViolation: null,
    violationDateTime: null,
    enforcerId: "",
    driverSignature: "",
    licenseImageUrl: "",
  );

  Ticket get getTicket => _ticket;
  Ticket get lastPrintedTicket => _lastPrintedTicket;

  void updateTicket(Ticket ticket) {
    _ticket = ticket;
    print("TICKET FROM TICKET PROVIDER");
    print(_ticket);
    notifyListeners();
  }
}
