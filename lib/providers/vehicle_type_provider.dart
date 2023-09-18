import '../config/utils/exports.dart';

class VehicleTypeProvider extends ChangeNotifier {
  List<VehicleType> _vehicleTypes = [];

  List<VehicleType> get vehicleTypes => _vehicleTypes;

  void setVehicleTypes(List<VehicleType> vehicleTypes) {
    _vehicleTypes = vehicleTypes;
    notifyListeners();
  }

  void clearVehicleTypes() {
    _vehicleTypes = [];
    notifyListeners();
  }
}