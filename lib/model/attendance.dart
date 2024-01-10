import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/model/schedule.dart';

class Attendance {
  final String? id;
  final String enforcerId;
  final EnforcerSchedule schedule;
  final Timestamp timeIn;
  final Timestamp? timeOut;

  Attendance({
    this.id,
    required this.enforcerId,
    required this.schedule,
    required this.timeIn,
    this.timeOut,
  });

  Attendance copyWith({
    String? id,
    EnforcerSchedule? schedule,
    Timestamp? timeIn,
    Timestamp? timeOut,
  }) {
    return Attendance(
      id: id ?? this.id,
      enforcerId: enforcerId,
      schedule: schedule ?? this.schedule,
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schedule': schedule.toJson(),
      'enforcerId': enforcerId,
      'timeIn': timeIn,
      'timeOut': timeOut,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map, String id) {
    return Attendance(
      id: id,
      schedule: EnforcerSchedule.fromJson(
        map['schedule'],
        map['schedule']['id'],
      ),
      enforcerId: map['schedule']['enforcerId'],
      timeIn: map['timeIn'],
      timeOut: map['timeOut'],
    );
  }
}
