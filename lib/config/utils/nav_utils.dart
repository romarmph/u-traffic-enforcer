import '../../config/utils/exports.dart';
import '../../pages/home/recent_ticket_view.dart';

void goHome() {
  Navigator.of(navigatorKey.currentContext!).pushNamed(
    "/",
  );
}

void goCreateTicket() {
  Navigator.of(navigatorKey.currentContext!).pushNamed(
    "/ticket/create",
  );
}

void goSelectViolation() {
  Navigator.of(navigatorKey.currentContext!).pushNamed(
    "/ticket/violations",
  );
}

void goPreviewTicket() {
  Navigator.of(navigatorKey.currentContext!).pushNamed(
    "/ticket/preview",
  );
}

void goPrinter() {
  Navigator.of(navigatorKey.currentContext!).pushNamed(
    "/printer/",
  );
}

void goPrinterScanner() {
  Navigator.of(navigatorKey.currentContext!).pushNamed(
    "/printer/scan",
  );
}

void goChangePassword() {
  Navigator.of(navigatorKey.currentContext!).pushNamed(
    "/settings/updatepassword",
  );
}

void goRequestLeave() {
  Navigator.of(navigatorKey.currentContext!).pushNamed(
    "/settings/leave",
  );
}

void popCurrent() {
  Navigator.of(navigatorKey.currentContext!).pop();
}

void viewRecentTicket(Ticket ticket, BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => RecentTicketView(ticket: ticket),
    ),
  );
}
