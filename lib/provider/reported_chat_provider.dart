import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/models/reported_chat_model.dart';

class ReportedChatProvider with ChangeNotifier {
  List<ReportedChat> _reports = [];
  List<ReportedChat> _selectedReports = [];
  int _currentPage = 1;
  int _pageSize = 10;
  int _totalItems = 0;
  bool _isLoading = false;
  String? _error;
  final String userToken;

  ReportedChatProvider({required this.userToken});

  List<ReportedChat> get reports => _reports;
  List<ReportedChat> get selectedReports => _selectedReports;
  int get currentPage => _currentPage;
  int get totalPages => (_totalItems / _pageSize).ceil();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchReports(int page) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          '${Config.apiUrl}${Config.getReportedChat}?page=$page&page_size=$_pageSize',
        ),
        headers: {'Authorization': 'Bearer $userToken'},
      );
      final jsonData = json.decode(response.body);

      print("INI JSON DATA $jsonData");
      if (response.statusCode == 200) {
        final data = jsonData['Data'] as Map<String, dynamic>;
        final reportList = data['reports'] as List<dynamic>;
        _reports =
            reportList
                .map(
                  (item) => ReportedChat.fromJson(item as Map<String, dynamic>),
                )
                .toList();
        _currentPage = data['pagination']['page'] as int;
        _pageSize = data['pagination']['page_size'] as int;
        _totalItems = data['pagination']['total'] as int;
        print("INIIIIIIIIIIIIIIII REPORTES LENGTH ${reportList.length}");
      } else {
        _error = 'Failed to fetch reports: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching reports: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      fetchReports(page);
    }
  }

  void toggleReportSelection(ReportedChat report) {
    if (_selectedReports.contains(report)) {
      _selectedReports.remove(report);
    } else {
      _selectedReports.add(report);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedReports.clear();
    notifyListeners();
  }
}
