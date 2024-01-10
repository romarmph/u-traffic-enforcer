import 'package:u_traffic_enforcer/config/enums/shift_period.dart';
import 'package:u_traffic_enforcer/config/utils/exports.dart';

class EnforcerSchedule {
  final String? id;
  final String enforcerId;
  final String enforcerName;
  final ShiftPeriod shift;
  final String postId;
  final String postName;
  final String createdBy;
  final String updatedBy;
  final Timestamp? scheduleDay;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  EnforcerSchedule({
    this.id,
    required this.enforcerId,
    required this.enforcerName,
    required this.shift,
    this.postId = "",
    this.postName = "",
    required this.createdBy,
    this.updatedBy = "",
    required this.createdAt,
    this.updatedAt,
    this.scheduleDay,
  });

  factory EnforcerSchedule.fromJson(Map<String, dynamic> json, String id) {
    return EnforcerSchedule(
      id: id,
      enforcerId: json['enforcerId'],
      enforcerName: json['enforcerName'],
      shift: json['shift'].toString().toShiftPeriod,
      postId: json['postId'],
      postName: json['postName'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      scheduleDay: json['scheduleDay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enforcerId': enforcerId,
      'enforcerName': enforcerName,
      'shift': shift.name,
      'postId': postId,
      'postName': postName,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'scheduleDay': scheduleDay,
    };
  }

  // TO String
  @override
  String toString() {
    return 'EnforcerSchedule(id: $id, enforcerId: $enforcerId, enforcerName: $enforcerName, shift: $shift, postId: $postId, postName: $postName, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  EnforcerSchedule copyWith({
    String? id,
    String? enforcerId,
    String? enforcerName,
    ShiftPeriod? shift,
    String? postId,
    String? postName,
    String? createdBy,
    String? updatedBy,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Timestamp? scheduleDay,
  }) {
    return EnforcerSchedule(
      id: id ?? this.id,
      enforcerId: enforcerId ?? this.enforcerId,
      enforcerName: enforcerName ?? this.enforcerName,
      shift: shift ?? this.shift,
      postId: postId ?? this.postId,
      postName: postName ?? this.postName,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      scheduleDay: scheduleDay ?? this.scheduleDay,
    );
  }
}
