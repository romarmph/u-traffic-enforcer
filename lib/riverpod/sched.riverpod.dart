import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/database/enforcer_sched_db_helper.dart';
import 'package:u_traffic_enforcer/model/schedule.dart';

final schedProviderStream = StreamProvider<EnforcerSchedule?>((ref) {
  final enforcer = AuthService().currentUser;
  DateTime now = DateTime.now();
  DateTime date = DateTime(now.year, now.month, now.day);

  return ScheduleDBHelper.instance
      .getEnforcerSchedules(enforcer!.uid, date.toTimestamp);
});

final schedProvider = Provider<EnforcerSchedule?>((ref) {
  return ref.watch(schedProviderStream).asData?.value;
});
