import '../../../config/utils/exports.dart';

class CreateTicketFormNotifier extends ChangeNotifier {
  bool _isDriverNotPresent = false;
  bool _isVehicleOwnedByDriver = false;

  String _driverName = "";
  String _driverAddress = "";

  bool get isDriverNotPresent => _isDriverNotPresent;
  bool get isVehicleOwnedByDriver => _isVehicleOwnedByDriver;

  String get driverName => _driverName;
  String get driverAddress => _driverAddress;

  void setIsDriverNotPresent(bool value) {
    _isDriverNotPresent = value;
    notifyListeners();
  }

  void setIsVehicleOwnedByDriver(bool value) {
    _isVehicleOwnedByDriver = value;
    notifyListeners();
  }

  void setDriverName(String value) {
    _driverName = value;
    notifyListeners();
  }

  void setDriverAddress(String value) {
    _driverAddress = value;
    notifyListeners();
  }

  void reset() {
    _isDriverNotPresent = false;
    _isVehicleOwnedByDriver = false;
    _driverName = "";
    _driverAddress = "";
    notifyListeners();
  }
}
