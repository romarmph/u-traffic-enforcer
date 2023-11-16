import 'package:u_traffic_enforcer/config/utils/exports.dart';

final enforcerStreamProvider = StreamProvider<Enforcer>((ref) {
  return EnforcerDBHelper.instance.getCurrentEnforcer();
});

final enforcerProvider = Provider<Enforcer>((ref) {
  final enforcer = ref.watch(enforcerStreamProvider);
  return enforcer.asData!.value;
});
