import 'package:u_traffic_enforcer/config/enums/shift_period.dart';
import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/model/attendance.dart';

class AttendanceDBHelper {
  const AttendanceDBHelper._();

  static const AttendanceDBHelper _instance = AttendanceDBHelper._();
  static AttendanceDBHelper get instance => _instance;

  static final _firestore = FirebaseFirestore.instance;
  static final _collection = _firestore.collection('attendance');

  Stream<Attendance?> getAttendance(
    String enforcerId,
    Timestamp day,
    ShiftPeriod shift,
  ) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    Timestamp start, end;

    if (shift == ShiftPeriod.morning) {
      start = Timestamp.fromDate(date.subtract(const Duration(hours: 19)));
      end = Timestamp.fromDate(date.add(const Duration(hours: 1)));
    } else if (shift == ShiftPeriod.afternoon) {
      start = Timestamp.fromDate(date.subtract(const Duration(hours: 13)));
      end = Timestamp.fromDate(date.add(const Duration(hours: 9)));
    } else {
      start = Timestamp.fromDate(date.subtract(const Duration(hours: 3)));
      end = Timestamp.fromDate(date.add(const Duration(hours: 5)));
    }

    return _collection
        .where('enforcerId', isEqualTo: enforcerId)
        .where('schedule.scheduleDay', isGreaterThanOrEqualTo: start)
        .where('schedule.scheduleDay', isLessThan: end)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return Attendance.fromMap(
          snapshot.docs.first.data(),
          snapshot.docs.first.id,
        );
      } else {
        return null;
      }
    });
  }

  Future<void> timeIn(Attendance attendance) async {
    await _collection.add(attendance.toMap());
  }

  Future<void> timeOut(Attendance attendance) async {
    print(attendance.id);
    await _collection.doc(attendance.id).update(attendance.toMap());
  }
}
