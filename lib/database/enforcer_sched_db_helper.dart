import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/model/schedule.dart';

class ScheduleDBHelper {
  const ScheduleDBHelper._();

  static const ScheduleDBHelper _instance = ScheduleDBHelper._();
  static ScheduleDBHelper get instance => _instance;

  static final _firestore = FirebaseFirestore.instance;
  static final _collection = _firestore.collection('enforcerSchedules');

  Stream<EnforcerSchedule?> getEnforcerSchedules(
      String enforcerId, Timestamp day) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    Timestamp start = Timestamp.fromDate(date);
    Timestamp end = Timestamp.fromDate(date.add(const Duration(days: 1)));

    return _collection
        .where('enforcerId', isEqualTo: enforcerId)
        .where('scheduleDay', isGreaterThanOrEqualTo: start)
        .where('scheduleDay', isLessThan: end)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return EnforcerSchedule.fromJson(
          snapshot.docs.first.data(),
          snapshot.docs.first.id,
        );
      } else {
        return null;
      }
    });
  }
}
