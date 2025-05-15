import 'package:flutter/material.dart';

import 'package:pa2_kelompok07/core/models/notification_response_model.dart';

class NotificationQueryProvider extends ChangeNotifier {
  List<NotificationPayload>? _cachedNotifications;

  List<NotificationPayload>? get cachedNotifications => _cachedNotifications;

  void setCachedNotifications(List<NotificationPayload> notifications) {
    _cachedNotifications = notifications;
    notifyListeners();
  }

  void clearCache() {
    _cachedNotifications = null;
    notifyListeners();
  }
}
