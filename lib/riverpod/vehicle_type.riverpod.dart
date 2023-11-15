import 'package:u_traffic_enforcer/config/utils/exports.dart';

final vehicleTypeStreamProvider = StreamProvider<List<VehicleType>>(
  (ref) => VehicleTypeDBHelper.instance.getVehicleTypesStream(),
);

final vehicleTypeProvider = Provider<List<VehicleType>>((ref) {
  return ref.watch(vehicleTypeStreamProvider).when(
        data: (data) => data,
        error: (error, stackTrace) => [],
        loading: () => [],
      );
});
