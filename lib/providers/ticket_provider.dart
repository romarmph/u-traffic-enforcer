import '../../../config/utils/exports.dart';

class TicketProvider extends ChangeNotifier {
  Ticket _ticket = Ticket(
    id: "",
    ticketNumber: 0,
    licenseNumber: "",
    driverName: "",
    phone: "",
    email: "",
    address: "",
    vehicleType: "",
    engineNumber: "",
    chassisNumber: "",
    plateNumber: "",
    vehicleOwner: "",
    vehicleOwnerAddress: "",
    enforcerID: "",
    enforcerName: "",
    status: TicketStatus.unpaid,
    birthDate: Timestamp.now(),
    dateCreated: Timestamp.now(),
    violationDateTime: Timestamp.now(),
    violationPlace: const ULocation(
      address: "",
      lat: 0.0,
      long: 0.0,
    ),
    violationsID: [],
  );

  Ticket get ticket => _ticket;

  void updateTicket(Ticket ticket) {
    _ticket = ticket;
    notifyListeners();
  }
}
