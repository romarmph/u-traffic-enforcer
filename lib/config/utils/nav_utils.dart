import '../../config/utils/exports.dart';

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

void goPreviewLicense() {
  Navigator.of(navigatorKey.currentContext!).pushNamed(
    "/ticket/scanpreview",
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
