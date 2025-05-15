import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/services/pdf_service.dart';
import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProvider extends ChangeNotifier {
  String _adminToken = '';

  String get adminToken => _adminToken;

  List<ListLaporanModel> _reports = [];
  List<ListLaporanModel> _originalReports =
      []; // Tambahan untuk menyimpan data asli
  bool _isLoading = false;
  String? _error;
  final int _pageSize = 10;
  int _currentPage = 1;
  int _totalPages = 1;
  final UserProvider _userProvider;

  AdminProvider(this._userProvider);

  List<ListLaporanModel> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  List<ListLaporanModel> _selectedReports = [];

  List<ListLaporanModel> get selectedReports => _selectedReports;

  // Method untuk menambah/menghapus laporan yang dipilih
  void toggleReportSelection(ListLaporanModel report) {
    if (_selectedReports.contains(report)) {
      _selectedReports.remove(report);
    } else {
      _selectedReports.add(report);
    }
    notifyListeners();
  }

  // Method untuk download laporan yang dipilih
  Future<File> downloadSelectedReports() async {
    if (_selectedReports.isEmpty) {
      throw Exception("Tidak ada laporan yang dipilih");
    }

    // Implementasi download laporan yang dipilih
    // Ganti dengan logika download sesuai kebutuhan Anda
    // return await DocumentManagerService.generateReportsPdf({reports: _selectedReports, fileName: 'selected_reports_${DateTime.now().millisecondsSinceEpoch}', title: 'Laporan Kekerasan Terpilih'});
    return await DocumentManagerService.generateReportsPdf(
      reports: _selectedReports,
      fileName:
          'reports_page_$_currentPage${DateTime.now().millisecondsSinceEpoch}',
      title: 'Laporan Kekerasan - Halaman Yang dipilih',
    );
  }

  void searchReports(String query) {
    if (query.isEmpty) {
      _reports = List.from(
        _originalReports,
      ); // Reset ke data asli jika query kosong
    } else {
      final searchQuery = query.toLowerCase();
      _reports =
          _originalReports.where((report) {
            // Field yang akan dicari
            return report.noRegistrasi.toLowerCase().contains(searchQuery) ||
                report.status.toLowerCase().contains(searchQuery) ||
                report.kronologisKasus.toLowerCase().contains(searchQuery) ||
                report.alamatTkp.toLowerCase().contains(searchQuery) ||
                report.alamatDetailTkp.toLowerCase().contains(searchQuery) ||
                report.kategoriLokasiKasus.toLowerCase().contains(
                  searchQuery,
                ) ||
                report.tanggalKejadian.toString().toLowerCase().contains(
                  searchQuery,
                );
          }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchReports(int page) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await APIService().retrieveAvailableReportsAdminService(
        _userProvider.userToken!,
        page,
        _pageSize,
      );
      _originalReports = result['reports'] as List<ListLaporanModel>;
      _reports = List.from(_originalReports); // Buat salinan untuk filter/sort
      _totalPages =
          (result['totalItems'] as int? ?? _reports.length) ~/ _pageSize + 1;
      _currentPage = page;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterOrSortReports({String? statusFilter, bool sortByDateAsc = true}) {
    List<ListLaporanModel> filteredReports = List.from(_originalReports);
    print("STATUS FILTER: $statusFilter");
    if (statusFilter != null && statusFilter.isNotEmpty) {
      filteredReports =
          filteredReports
              .where(
                (report) =>
                    report.status.toLowerCase() == statusFilter.toLowerCase(),
              )
              .toList();
    }

    // Sort berdasarkan tanggal
    filteredReports.sort((a, b) {
      final dateA = a.tanggalKejadian;
      final dateB = b.tanggalKejadian;
      return sortByDateAsc ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });

    _reports = filteredReports;
    notifyListeners();
  }

  // Ganti halaman
  void goToPage(int page) {
    if (page >= 1 && page <= _totalPages && page != _currentPage) {
      fetchReports(page);
    }
  }

  void updateReport(String noRegistrasi, String newStatus) {
    final index = _reports.indexWhere(
      (report) => report.noRegistrasi == noRegistrasi,
    );

    print("TIDAKKK ADA DATA DI INDEX $index");
    if (index != -1) {
      print("TIDAKKK ADA DATA DI INDEX $index");
      updateReportByIndex(index, status: newStatus);
    }
  }

  void sortReports({String? groupByStatus, bool sortByDateAsc = true}) {
    List<ListLaporanModel> sortedReports = List.from(_originalReports);

    // Urutan status yang diinginkan
    const statusOrder = [
      'Laporan masuk',
      'Dilihat',
      'Diproses',
      'Selesai',
      'Dibatalkan',
    ];

    sortedReports.sort((a, b) {
      if (groupByStatus != null) {
        int indexA = statusOrder.indexOf(a.status);
        int indexB = statusOrder.indexOf(b.status);
        indexA = indexA == -1 ? statusOrder.length : indexA;
        indexB = indexB == -1 ? statusOrder.length : indexB;
        final statusComparison = indexA.compareTo(indexB);
        if (statusComparison != 0) return statusComparison;
      }

      final dateA = a.tanggalKejadian;
      final dateB = b.tanggalKejadian;
      return sortByDateAsc ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
    print("SPORYYYYYYYYYYYYYYY DIPANGGGILLL $groupByStatus");
    _reports = sortedReports;
    notifyListeners();
  }

  void updateReportByIndex(
    int index, {
    String? status,
    DateTime? tanggalKejadian,
    int? useridMelihat,
    String? waktuDilihat,
  }) {
    if (index >= 0 && index < _reports.length) {
      _reports[index] = _reports[index].copyWith(
        status: status,
        tanggalKejadian: tanggalKejadian,
        useridMelihat: useridMelihat,
        waktuDilihat: waktuDilihat,
      );
      notifyListeners();
    }
  }

  Future<File> downloadAllReports() async {
    try {
      // Ambil semua data dari semua halaman
      List<ListLaporanModel> allReports = [];
      for (int i = 1; i <= _totalPages; i++) {
        await fetchReports(i);
        allReports.addAll(_reports);
      }

      return await DocumentManagerService.generateReportsPdf(
        reports: allReports,
        fileName: 'all_reports_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Semua Laporan Kekerasan',
      );
    } catch (e) {
      throw Exception('Gagal mendownload semua laporan: $e');
    }
  }

  Future<File> downloadPageReports(int page) async {
    try {
      await fetchReports(page);
      return await DocumentManagerService.generateReportsPdf(
        reports: _reports,
        fileName:
            'reports_page_$_currentPage${DateTime.now().millisecondsSinceEpoch}',
        title: 'Laporan Kekerasan - Halaman $page',
      );
    } catch (e) {
      throw Exception('Gagal mendownload laporan halaman $page: $e');
    }
  }

  // Download laporan tunggal
  Future<File> downloadSingleReport(ListLaporanModel report) async {
    try {
      return await DocumentManagerService.generateReportsPdf(
        reports: [report],
        fileName:
            'report_${report.noRegistrasi}_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Laporan Kekerasan - ${report.noRegistrasi}',
      );
    } catch (e) {
      throw Exception('Gagal mendownload laporan tunggal: $e');
    }
  }

  /// Memuat token admin dari SharedPreferences.
  Future<void> loadAdminToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _adminToken = prefs.getString('adminToken') ?? '';
    notifyListeners();
  }

  /// Menyimpan token admin ke SharedPreferences dan memperbarui state.
  Future<void> saveAdminToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('adminToken', token);
    _adminToken = token;
    notifyListeners();
  }

  /// Menghapus token admin dari SharedPreferences dan memperbarui state.
  Future<void> clearAdminToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('adminToken');
    _adminToken = '';
    notifyListeners();
  }
}
