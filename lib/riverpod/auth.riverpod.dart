import 'package:u_traffic_enforcer/config/utils/exports.dart';

final authProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStreamProvider = StreamProvider<User?>((ref) {
  return ref.watch(authProvider).user;
});
