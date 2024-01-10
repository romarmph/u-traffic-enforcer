import 'package:u_traffic_enforcer/config/enums/shift_period.dart';
import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/database/attendance_db.dart';
import 'package:u_traffic_enforcer/model/attendance.dart';

final attendanceProvider = StreamProvider.family<Attendance?, ShiftPeriod>((ref, shift) {
  final enforcerId = AuthService().currentUser!.uid;
  final day = DateTime.now().toTimestamp;

  return AttendanceDBHelper.instance.getAttendance(enforcerId, day, shift);
});
