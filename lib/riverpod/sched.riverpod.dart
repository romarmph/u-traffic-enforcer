import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/database/enforcer_sched_db_helper.dart';
import 'package:u_traffic_enforcer/model/schedule.dart';

final schedProvider =
    StreamProvider.family<EnforcerSchedule?, String>((ref, enforcerId) {
  return ScheduleDBHelper.instance.getEnforcerSchedules(enforcerId);
});
