import 'package:u_traffic_enforcer/config/utils/exports.dart';

class Notification {
  final String? id;
  final String title;
  final String content;
  final NotificationContentType contentType;
  final NotificationType type;
  final bool isRead;
  final bool softDeleted;
  final Timestamp createdAt;
  final Timestamp softDeletedAt;

  const Notification({
    this.id,
    required this.title,
    required this.content,
    required this.contentType,
    required this.type,
    required this.isRead,
    required this.softDeleted,
    required this.createdAt,
    required this.softDeletedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
        title: json['title'],
        content: json['content'],
        contentType: json['contentType'],
        type: json['type'],
        isRead: json['isRead'],
        softDeleted: json['softDeleted'],
        createdAt: json['createdAt'],
        softDeletedAt: json['softDeletedAt']);
  }
}
