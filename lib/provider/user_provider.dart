import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/core/services/notification_service.dart';
import '../model/auth/login_request_model.dart';
import '../services/api_service.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  User? _user;
  String? _userToken;
  final _storage = const FlutterSecureStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('UserProvider');
  User? get user => _user;
  bool get isLoggedIn => _userToken != null;
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;
  int? get userId => _user?.id;
  bool _isTokenBeingHandled = false;
  static var client = http.Client();
  String get userToken => _userToken ?? '';

  UserProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadUserToken();
    if (isLoggedIn) {
      await _checkAndUpdateTokenOnLogin();
      await fetchUnreadCount();
    }
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> login(String identifier, String password) async {
    try {
      final response = await APIService().login(identifier, password);
      _user = response.data;
      _userToken = response.token;
      _logger.log("INI ADALAH LOG DARI USER TOKEN $_userToken");
      await setUserToken(_userToken!);
      await setUserDetails(_user!);

      await _checkAndUpdateTokenOnLogin();

      final pendingNotification =
          await NotificationService.instance.getPendingNotification();
      if (pendingNotification != null) {
        NotificationService.instance.navigateBasedOnNotification(
          pendingNotification,
        );
        await NotificationService.instance.clearPendingNotification();
      }

      notifyListeners();
      return true;
    } catch (e) {
      _logger.log('Error login: $e');
      return false;
    }
  }

  Future<bool> register(
    String email,
    String password,
    String fullName,
    String phoneNumber,
  ) async {
    try {
      final fcmToken = await NotificationService.instance.getStoredFcmToken();
      print("Attempting to register with phone number: $phoneNumber");
      final response = await APIService().register(
        email,
        password,
        fullName,
        phoneNumber,
        fcmToken ?? "empty_token",
      );

      if (response.success != 200) {
        print(
          "Failed to register, server responded with status code: ${response.success} and body: ${response.data}",
        );
      }
      _user = response.data;
      await setUserToken(_userToken!);
      await setUserDetails(_user!);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error login: $e');
      return false;
    }
  }

  Future<void> setUserToken(String token) async {
    await _storage.write(key: 'userToken', value: token);
    _userToken = token;
  }

  Future<void> setUserDetails(User user) async {
    String userJson = jsonEncode(user.toJson());
    await _storage.write(key: 'userData', value: userJson);
    _user = user;
  }

  Future<void> loadUserDetails() async {
    String? userJson = await _storage.read(key: 'userData');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      _user = User.fromJson(userMap);
      await _updateUserNotificationToken();
    }
  }

  Future<void> loadUserToken() async {
    _userToken = await _storage.read(key: 'userToken');
    print(_userToken);
    if (_userToken != null) {
      await loadUserDetails();
    }
    notifyListeners();
  }

  Future<void> _updateUserNotificationToken() async {
    if (_user == null) return;

    try {
      final storedFcmToken = await _storage.read(key: 'fcm_token');
      if (storedFcmToken != null &&
          storedFcmToken != _user!.notificationToken) {
        _user = _user!.copyWith(notificationToken: storedFcmToken);

        await setUserDetails(_user!);
        _logger.log('Updated user notification token: $storedFcmToken');
      }
    } catch (e) {
      _logger.log('Error updating user notification token: $e');
    }
  }

  Future<void> logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
      }
    } catch (error) {
      print("Gagal memutuskan koneksi: $error");
    }

    await _storage.delete(key: 'userToken');
    await _storage.delete(key: 'userData');
    _userToken = null;
    _user = null;

    notifyListeners();
  }

  Future<void> _checkAndUpdateTokenOnLogin() async {
    if (!isLoggedIn || userId == null || _isTokenBeingHandled) {
      _logger.log(
        _isTokenBeingHandled
            ? "Token already being handled"
            : "User not logged in, token stored locally only $isLoggedIn $userId",
      );
      return;
    }

    try {
      final storedToken = await _storage.read(key: 'fcm_token');
      if (storedToken != null) {
        await APIService().sendTokenToServer(storedToken);
        await _updateUserNotificationToken();
        await setUserDetails(_user!);
      }
    } catch (e) {
      _logger.log('Error checking token on login: $e');
    } finally {
      _isTokenBeingHandled = false;
    }
  }

  Future<void> updateFcmToken(String newToken) async {
    await _storage.write(key: 'fcm_token', value: newToken);

    await APIService().sendTokenToServer(newToken);
    notifyListeners();
  }

  Future<void> fetchUnreadCount() async {
    try {
      if (!isLoggedIn ||
          userId == null ||
          _isTokenBeingHandled ||
          _user?.role == "admin") {
        _logger.log(
          _isTokenBeingHandled
              ? "Notificaition count alread retrieved"
              : "User not logged in, Handled notification to default '0'",
        );
        return;
      }
      _unreadCount = await APIService().fetchUnreadNotificationCount(
        _userToken!,
      );
    } catch (e) {
      _logger.log('Error fetching unread count: $e');
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      if (!isLoggedIn || userId == null || _isTokenBeingHandled) {
        _logger.log(
          _isTokenBeingHandled
              ? "Token already being handled"
              : "User not logged in, token stored locally only $isLoggedIn $userId",
        );
        return;
      }
      await APIService().markNotificationAsRead(_userToken!, notificationId);

      if (_unreadCount > 0) {
        _unreadCount = _unreadCount - 1;
      }
      notifyListeners();
    } catch (e) {
      _logger.log('Error fetching Mark Notification as Read: $e');
    }
  }

  /// Ini akan dipanggil oleh UI (ForgotPassword screen)
  Future<void> forgotPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) {
    return APIService.forgotPassword(
      email: email,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
