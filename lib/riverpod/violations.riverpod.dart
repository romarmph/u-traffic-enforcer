import 'package:u_traffic_enforcer/config/utils/exports.dart';

final violationsStreamProvider = StreamProvider<List<Violation>>((ref) {
  return ViolationsDatabase.instance.getViolationsStream();
});

final violationsListProvider = Provider<List<Violation>>((ref) {
  return ref.watch(violationsStreamProvider).when(
        data: (data) => data,
        error: (error, stackTrace) => [],
        loading: () => [],
      );
});

final selectedViolationsProvider = StateProvider<List<IssuedViolation>>(
  (ref) => [],
);
