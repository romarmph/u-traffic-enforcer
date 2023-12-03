import 'package:u_traffic_enforcer/config/utils/exports.dart';

final enforcerStreamProvider =
    StreamProvider.family<Enforcer, String>((ref, uid) {
  return EnforcerDBHelper.instance.getCurrentEnforcer(uid);
});

final enforcerProvider = Provider<Enforcer>((ref) {
  final currentUser = AuthService().currentUser;
  final enforcer = ref.watch(enforcerStreamProvider(currentUser!.uid));
  return enforcer.asData!.value;
});
