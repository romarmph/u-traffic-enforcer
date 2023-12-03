import 'package:u_traffic_enforcer/config/utils/exports.dart';

class TrafficPost {
  final String? id;
  final String name;
  final int number;
  final ULocation location;
  final String createdBy;
  final String updatedBy;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  const TrafficPost({
    this.id,
    required this.name,
    required this.number,
    required this.location,
    required this.createdBy,
    this.updatedBy = "",
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location.toJson(),
      'number': number,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory TrafficPost.fromJson(Map<String, dynamic> json, String? docId) {
    return TrafficPost(
      id: docId,
      name: json['name'],
      number: json['number'],
      location: ULocation.fromJson(json['location']),
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  TrafficPost copyWith({
    String? id,
    String? name,
    int? number,
    ULocation? location,
    String? createdBy,
    String? updatedBy,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return TrafficPost(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      location: location ?? this.location,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
