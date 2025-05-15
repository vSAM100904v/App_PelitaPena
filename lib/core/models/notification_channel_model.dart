import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

enum NotificationType {
  chat_message,
  appointment,
  reportStatus,
  unknown,
  trackingUpdate,
  admin_notification,
}

extension NotificationTypeExtension on NotificationType {
  String get stringValue {
    switch (this) {
      case NotificationType.chat_message:
        return 'chat_message';
      case NotificationType.appointment:
        return 'appointment';
      case NotificationType.reportStatus:
        return 'report_status';
      case NotificationType.trackingUpdate:
        return 'tracking_update';
      case NotificationType.admin_notification:
        return 'admin_notification';
      default:
        return 'unknown';
    }
  }

  String get value {
    switch (this) {
      case NotificationType.reportStatus:
        return 'report_status';
      case NotificationType.chat_message:
        return 'chat_message';
      case NotificationType.appointment:
        return 'appointment';
      case NotificationType.trackingUpdate:
        return 'tracking_update';
      case NotificationType.admin_notification:
      case NotificationType.unknown:
        return 'unknown';
    }
  }

  static NotificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'chat_message':
        return NotificationType.chat_message;
      case 'appointment':
        return NotificationType.appointment;
      case 'report_status':
        return NotificationType.reportStatus;
      case 'tracking_update' || 'tracking_report':
        return NotificationType.trackingUpdate;
      case "admin_notification":
        return NotificationType.admin_notification;
      default:
        return NotificationType.chat_message;
    }
  }
}

enum ReportStatus {
  received,
  inProgress,
  completed,
  cancelled,
  requiresAction,
  waitingApproval,
}

extension ReportStatusExtension on ReportStatus {
  String get stringValue {
    switch (this) {
      case ReportStatus.received:
        return 'received';
      case ReportStatus.inProgress:
        return 'in_progress';
      case ReportStatus.completed:
        return 'completed';
      case ReportStatus.cancelled:
        return 'cancelled';
      case ReportStatus.requiresAction:
        return 'requires_action';
      case ReportStatus.waitingApproval:
        return 'waiting_approval';
    }
  }

  String get displayText {
    switch (this) {
      case ReportStatus.received:
        return 'Laporan Diterima';
      case ReportStatus.inProgress:
        return 'Laporan Diproses';
      case ReportStatus.completed:
        return 'Laporan Selesai';
      case ReportStatus.cancelled:
        return 'Laporan Dibatalkan';
      case ReportStatus.requiresAction:
        return 'Perlu Tindakan';
      case ReportStatus.waitingApproval:
        return 'Menunggu Persetujuan';
    }
  }
}

class NotificationContent {
  final String? title;
  final String? body;
  final String? imageUrl;

  NotificationContent({this.title, this.body, this.imageUrl});

  factory NotificationContent.fromRemoteNotification(
    RemoteNotification? notification,
  ) {
    return NotificationContent(
      title: notification?.title,
      body: notification?.body,
      imageUrl: notification?.android?.imageUrl,
    );
  }
  Map<String, dynamic> toJson() {
    return {'title': title, 'body': body, 'imageUrl': imageUrl};
  }

  factory NotificationContent.fromJson(Map<String, dynamic> json) {
    return NotificationContent(
      title: json['title'] as String?,
      body: json['body'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  @override
  String toString() {
    return 'NotificationContent{title: $title, body: $body, imageUrl: $imageUrl}';
  }
}

class ReportStatusData {
  final String reportId;
  final ReportStatus status;
  final String? updatedBy;
  final DateTime? updatedAt;
  final String? notes;

  ReportStatusData({
    required this.reportId,
    required this.status,
    this.updatedBy,
    this.updatedAt,
    this.notes,
  });

  factory ReportStatusData.fromMap(Map<String, dynamic> data) {
    return ReportStatusData(
      reportId: data['reportId'] as String,
      status: _parseReportStatus(data['status'] as String),
      updatedBy: data['updatedBy'] as String?,
      updatedAt:
          data['updatedAt'] != null
              ? DateTime.parse(data['updatedAt'] as String)
              : null,
      notes: data['notes'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'status': status.stringValue,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt?.toIso8601String(),
      'notes': notes,
    };
  }

  factory ReportStatusData.fromJson(Map<String, dynamic> json) {
    return ReportStatusData(
      reportId: json['reportId'] as String,
      status: _parseReportStatus(json['status'] as String),
      updatedBy: json['updatedBy'] as String?,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
      notes: json['notes'] as String?,
    );
  }
  static ReportStatus _parseReportStatus(String status) {
    switch (status) {
      case 'received':
        return ReportStatus.received;
      case 'in_progress':
        return ReportStatus.inProgress;
      case 'completed':
        return ReportStatus.completed;
      case 'cancelled':
        return ReportStatus.cancelled;
      case 'requires_action':
        return ReportStatus.requiresAction;
      case 'waiting_approval':
        return ReportStatus.waitingApproval;
      default:
        return ReportStatus.received;
    }
  }
}

class NotificationData {
  final NotificationType type;
  final String? chat_messageId;
  final String? appointmentId;
  final ReportStatusData? reportStatusData;

  NotificationData({
    required this.type,
    this.chat_messageId,
    this.appointmentId,
    this.reportStatusData,
  });

  factory NotificationData.fromMap(Map<String, dynamic> data) {
    print('📥 Incoming data map: ${jsonEncode(data)}');

    final typeString = data['type']?.toString().toLowerCase();
    print('🔍 Parsed type string: $typeString');

    final type = _parseNotificationType(typeString);
    print('✅ Converted to NotificationType: $type');

    final reportData = ReportStatusData.fromMap(data);

    if (reportData != null) {
      print('🧾 Parsed ReportStatusData: ${reportData.toJson()}');
    }
    print(
      "INIIII REPORTTTTTTTTTTTT DATAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA $reportData",
    );
    final notificationData = NotificationData(
      type: type,
      chat_messageId: data['chat_messageId'] as String?,
      appointmentId: data['appointmentId'] as String?,
      reportStatusData: reportData,
    );

    print('📦 Final NotificationData: ${notificationData.toJson()}');

    return notificationData;
  }

  static NotificationType _parseNotificationType(String? typeString) {
    switch (typeString) {
      case 'appointment':
        return NotificationType.appointment;
      case 'report_status':
        return NotificationType.reportStatus;
      case 'chat_message':
        return NotificationType.chat_message;
      case 'tracking_update':
        return NotificationType.trackingUpdate;
      default:
        return NotificationType.chat_message;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      if (chat_messageId != null) 'chat_messageId': chat_messageId,
      if (appointmentId != null) 'appointmentId': appointmentId,
      if (reportStatusData != null) ...reportStatusData!.toJson(),
    };
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    final type = _parseNotificationType(json['type'] as String?);

    return NotificationData(
      type: type,
      chat_messageId: json['chat_messageId'] as String?,
      appointmentId: json['appointmentId'] as String?,
      reportStatusData:
          type == NotificationType.reportStatus
              ? ReportStatusData.fromJson(json)
              : null,
    );
  }
  @override
  String toString() {
    return 'NotificationData{'
        'type: ${type.stringValue}, '
        'chat_messageId: $chat_messageId, '
        'appointmentId: $appointmentId, '
        'reportStatusData: $reportStatusData'
        '}';
  }
}

class AppNotification {
  final NotificationContent content;
  final NotificationData data;
  final DateTime receivedTime;

  AppNotification({
    required this.content,
    required this.data,
    DateTime? receivedTime,
  }) : receivedTime = receivedTime ?? DateTime.now();

  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    return AppNotification(
      content: NotificationContent.fromRemoteNotification(message.notification),
      data: NotificationData.fromMap(message.data),
      receivedTime: message.sentTime?.toLocal(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'content': content.toJson(),
      'data': data.toJson(),
      'receivedTime': receivedTime.toIso8601String(),
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      content: NotificationContent.fromJson(
        json['content'] as Map<String, dynamic>,
      ),
      data: NotificationData.fromJson(json['data'] as Map<String, dynamic>),
      receivedTime: DateTime.parse(json['receivedTime'] as String),
    );
  }
  @override
  String toString() {
    return 'AppNotification{'
        'content: $content, '
        'data: $data, '
        'receivedTime: $receivedTime'
        '}';
  }
}
