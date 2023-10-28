import '../../../config/utils/exports.dart';

class CreateTicketFormNotifier extends ChangeNotifier {
  bool _isDriverNotPresent = false;
  bool _hasNoLicense = false;
  bool _isVehicleOwnedByDriver = false;

  bool get isDriverNotPresent => _isDriverNotPresent;
  bool get hasNoLicense => _hasNoLicense;
  bool get isVehicleOwnedByDriver => _isVehicleOwnedByDriver;

  void setIsDriverNotPresent(bool value) {
    _isDriverNotPresent = value;
    notifyListeners();
  }

  void setIsVehicleOwnedByDriver(bool value) {
    _isVehicleOwnedByDriver = value;
    notifyListeners();
  }

  void setHasNoLicense(bool value) {
    _hasNoLicense = value;
    notifyListeners();
  }

  void reset() {
    _isDriverNotPresent = false;
    _hasNoLicense = false;
    _isVehicleOwnedByDriver = false;

    notifyListeners();
  }
}
