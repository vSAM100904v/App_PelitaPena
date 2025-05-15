import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pa2_kelompok07/core/models/notification_channel_model.dart';

class NotificationPayload {
  final int id;
  final int userId;
  final NotificationType type;
  final String title;
  final String body;
  final FCMNotificationData data;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationPayload({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      type: NotificationTypeExtension.fromString(json['type'] as String),
      title: json['title'] as String,
      body: json['body'] as String,
      data: FCMNotificationData.fromJson(
        jsonDecode(json['data'] as String) as Map<String, dynamic>,
      ),
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  factory NotificationPayload.fromFCMData({
    required int userId,
    required String title,
    required String body,
    required FCMNotificationData data,
    required DateTime now,
  }) {
    return NotificationPayload(
      id: 0, // Will be set by database
      userId: userId,
      type: data.type,
      title: title,
      body: body,
      data: data,
      isRead: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.value,
      'title': title,
      'body': body,
      'data': jsonEncode(data.toJson()),
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  NotificationPayload copyWith({
    int? id,
    int? userId,
    NotificationType? type,
    String? title,
    String? body,
    FCMNotificationData? data,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationPayload(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'NotificationPayload(id: $id, userId: $userId, type: $type, title: $title, '
        'body: $body, data: $data, isRead: $isRead, createdAt: $createdAt, '
        'updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationPayload &&
        other.id == id &&
        other.userId == userId &&
        other.type == type &&
        other.title == title &&
        other.body == body &&
        mapEquals(other.data.toJson(), data.toJson()) &&
        other.isRead == isRead &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        title.hashCode ^
        body.hashCode ^
        data.hashCode ^
        isRead.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

class FCMNotificationData {
  final NotificationType type;
  final String? reportId;
  final String? status;
  final int? updatedBy;
  final String? updatedAt;
  final String? notes;
  final String? deepLink;
  final String? imageUrl;

  FCMNotificationData({
    required this.type,
    this.reportId,
    this.status,
    this.updatedBy,
    this.updatedAt,
    this.notes,
    this.deepLink,
    this.imageUrl,
  });

  factory FCMNotificationData.fromJson(Map<String, dynamic> json) {
    return FCMNotificationData(
      type: NotificationTypeExtension.fromString(json['type'] as String),
      reportId: json['reportId'] as String?,
      status: json['status'] as String?,
      updatedBy: json['updatedBy'] as int?,
      updatedAt: json['updatedAt'] as String?,
      notes: json['notes'] as String?,
      deepLink: json['deepLink'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'reportId': reportId,
      'status': status,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'notes': notes,
      'deepLink': deepLink,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

class NotificationResponse {
  final List<NotificationPayload> notifications;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  NotificationResponse({
    required this.notifications,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final notificationsData = data['notifications'] as List;
    final pagination = data['pagination'] as Map<String, dynamic>;

    return NotificationResponse(
      notifications:
          notificationsData
              .map(
                (item) =>
                    NotificationPayload.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      total: pagination['total'] as int,
      page: pagination['page'] as int,
      limit: pagination['limit'] as int,
      totalPages: pagination['total_pages'] as int,
    );
  }
}
