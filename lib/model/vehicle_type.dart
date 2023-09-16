import 'package:u_traffic_enforcer/config/utils/exports.dart';

class VehicleType {
  final String id;
  final String type;
  final Timestamp dateCreated;
  final Timestamp dateEdited;
  final String createdBy;
  final String editedBy;
  final bool isPUV;

  VehicleType({
    required this.id,
    required this.type,
    required this.dateCreated,
    required this.dateEdited,
    required this.createdBy,
    required this.editedBy,
    required this.isPUV,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json['id'],
      type: json['type'],
      dateCreated: json['dateCreated'],
      dateEdited: json['dateEdited'],
      createdBy: json['createdByUserId'],
      editedBy: json['editedByUserId'],
      isPUV: json['isPublicUtilityVehicle'],
    );
  }
}
