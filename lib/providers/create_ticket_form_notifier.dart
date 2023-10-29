import '../../../config/utils/exports.dart';

class CreateTicketFormNotifier extends ChangeNotifier {
  String _vehicleTypeID = "";
  bool _isDriverNotPresent = false;
  bool _hasNoLicense = false;
  bool _isVehicleOwnedByDriver = false;

  String get vehicleTypeID => _vehicleTypeID;
  bool get isDriverNotPresent => _isDriverNotPresent;
  bool get hasNoLicense => _hasNoLicense;
  bool get isVehicleOwnedByDriver => _isVehicleOwnedByDriver;

  void setVehicleTypeID(String value) {
    _vehicleTypeID = value;
    notifyListeners();
  }

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
    _vehicleTypeID = "";

    notifyListeners();
  }
}
