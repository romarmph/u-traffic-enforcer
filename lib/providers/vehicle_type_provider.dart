import '../config/utils/exports.dart';

class VehicleTypeProvider extends ChangeNotifier {
  List<VehicleType> _vehicleTypes = [];

  List<VehicleType> get vehicleTypes => _vehicleTypes;

  void setVehicleTypes(List<VehicleType> vehicleTypes) {
    _vehicleTypes = vehicleTypes;
    notifyListeners();
  }

  String getVehicleTypeName(String vehicleTypeID) {
    return _vehicleTypes
        .firstWhere((element) => element.id == vehicleTypeID)
        .typeName;
  }

  void clearVehicleTypes() {
    _vehicleTypes = [];
    notifyListeners();
  }
}
