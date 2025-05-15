import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class InternetProvider extends ChangeNotifier {
  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  InternetProvider() {
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    try {
      List<ConnectivityResult> results =
          await _connectivity.checkConnectivity();
      _updateStatus(results);

      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        List<ConnectivityResult> results,
      ) {
        _updateStatus(results);
      });
    } catch (e) {
      debugPrint("Error checking connectivity: $e");
    }
  }

  void _updateStatus(List<ConnectivityResult> results) {
    _hasInternet =
        results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
