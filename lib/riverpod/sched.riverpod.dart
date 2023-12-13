import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/database/enforcer_sched_db_helper.dart';
import 'package:u_traffic_enforcer/model/schedule.dart';

final schedProviderStream =
    StreamProvider.family<EnforcerSchedule?, String>((ref, enforcerId) {
  return ScheduleDBHelper.instance.getEnforcerSchedules(enforcerId);
});

final schedProvider = Provider.family<EnforcerSchedule?, String>((ref, id) {
  return ref.watch(schedProviderStream(id)).when(
        data: (data) => data,
        error: (error, stackTrace) => null,
        loading: () => null,
      );
});
