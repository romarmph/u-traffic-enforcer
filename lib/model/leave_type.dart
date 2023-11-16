import 'package:u_traffic_enforcer/config/utils/exports.dart';

class LeaveType {
  final String? id;
  final String type;
  final String description;
  final String createdBy;
  final String editedBy;
  final Timestamp createdAt;
  final Timestamp editedAt;

  LeaveType({
    this.id,
    required this.type,
    required this.description,
    required this.createdBy,
    required this.editedBy,
    required this.createdAt,
    required this.editedAt,
  });

  LeaveType copyWith({
    String? id,
    String? type,
    String? description,
    String? createdBy,
    String? editedBy,
    Timestamp? createdAt,
    Timestamp? editedAt,
  }) {
    return LeaveType(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      editedBy: editedBy ?? this.editedBy,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json["id"],
      type: json["type"],
      description: json["description"],
      createdBy: json["createdBy"],
      editedBy: json["editedBy"],
      createdAt: json["createdAt"],
      editedAt: json["editedAt"],
    );
  }
}
