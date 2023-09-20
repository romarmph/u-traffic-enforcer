import '../config/utils/exports.dart';

class VehicleTypeDBHelper {
  VehicleTypeDBHelper._();

  static final VehicleTypeDBHelper _instance = VehicleTypeDBHelper._();

  static VehicleTypeDBHelper get instance => _instance;

  final _firebase = FirebaseFirestore.instance;

  Future<List<VehicleType>> getVehicleTypes() async {
    final snapshot = await _firebase.collection('vehicleTypes').get();

    return snapshot.docs.map((doc) {
      return VehicleType.fromJson(
        doc.data(),
        doc.id,
      );
    }).toList();
  }
}
