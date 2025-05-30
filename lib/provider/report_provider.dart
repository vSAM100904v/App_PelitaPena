import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/core/interface/filter_abstract.dart';
import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import 'package:pa2_kelompok07/model/report/tracking_report_model.dart';
import '../model/report/full_report_model.dart';
import '../services/api_service.dart';

class ReportProvider with ChangeNotifier implements ReportFiltering {
  // ResponseModel? reports;
  bool isLoading = false;
  String? errorMessage;
  final Logger _logger = Logger("Report Provider");
  List<ListLaporanModel> _reports = [];
  List<ListLaporanModel> _originalReports = [];
  List<ListLaporanModel> get reports => _reports;

  DetailResponseModel? detailReport;

  /// Fetches reports for the currently logged-in user.
  ///
  /// This function first sets `isLoading` to `true`, then attempts to fetch
  /// the reports. If the request is successful, `isLoading` is set to `false`
  /// and the response is stored in `reports`. If an error occurs, `isLoading`
  /// is also set to `false` and the error is stored in `errorMessage`.
  Future<void> fetchReports() async {
    _setLoading(true);
    try {
      _logger.log("FETHING DATA DIPANGGILLLLLLLLLLLLLLLLLLL");
      var resp = await APIService().fetchUserReports();
      _logger.log("REPORTS: ${resp.data}");

      _reports = resp.data;
      _originalReports = List.from(_reports);

      _setLoading(false);
    } catch (e) {
      _handleError(e);
    } finally {
      _setLoading(false);
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

  Future<void> createTracking({
    required String noRegistrasi,
    required String keterangan,
    List<File>? documents,
  }) async {
    _setLoading(true);
    notifyListeners();
    try {
      final response = await APIService().createTrackingLaporan(
        noRegistrasi: noRegistrasi,
        keterangan: keterangan,
        documents: documents,
      );

      // Parsing data dari response['Data']
      final trackingData = response['Data'];
      if (trackingData == null) {
        throw Exception("No 'Data' field in response");
      }

      final newTracking = TrackingLaporanModel(
        id: trackingData['id'] as int, // Ambil id dari Data
        noRegistrasi: trackingData['no_registrasi'] as String,
        keterangan: trackingData['keterangan'] as String,
        documents:
            trackingData['document'] != null &&
                    trackingData['document']['urls'] != null
                ? List<String>.from(trackingData['document']['urls'])
                : documents?.map((file) => file.path).toList() ?? [],
        createdAt: DateTime.parse(
          trackingData['created_at'] ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          trackingData['updated_at'] ?? DateTime.now().toIso8601String(),
        ),
      );

      if (detailReport != null) {
        _logger.log(
          "Before adding new tracking: ${detailReport!.data.trackingLaporan.length} items",
        );
        detailReport!.data.trackingLaporan.insert(0, newTracking);
        _logger.log(
          "After adding new tracking: ${detailReport!.data.trackingLaporan.length} items",
        );
        _logger.log("New tracking added: ${newTracking.toJson()}");
      } else {
        // Jika detailReport null, fetch data dulu
        _logger.log("detailReport is null, fetching report details...");
        detailReport = await APIService().getFullReportDetails(
          noRegistrasi,
          false,
        );
        if (detailReport != null) {
          detailReport!.data.trackingLaporan.insert(0, newTracking);
          _logger.log(
            "Fetched and added new tracking: ${detailReport!.data.trackingLaporan.length} items",
          );
        } else {
          throw Exception(
            "Failed to fetch report details, cannot create tracking",
          );
        }
      }
    } catch (e) {
      _logger.log("Error in createTracking: $e");
      _handleError(e);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> updateTracking({
    required String id,
    String? keterangan,
    List<File>? documents,
  }) async {
    _setLoading(true);
    notifyListeners();
    try {
      final response = await APIService().updateTrackingLaporan(
        // accessToken: _userProvider.userToken,
        id: id,
        keterangan: keterangan,
        documents: documents,
      );

      if (detailReport != null) {
        final index = detailReport!.data.trackingLaporan.indexWhere(
          (t) => t.id.toString() == id,
        );
        if (index != -1) {
          final existing = detailReport!.data.trackingLaporan[index];
          detailReport!.data.trackingLaporan[index] = TrackingLaporanModel(
            id: existing.id,
            noRegistrasi: existing.noRegistrasi,
            keterangan: keterangan ?? existing.keterangan,
            documents:
                response['Data']["document"]["urls"]
                    ?.map((file) => file.path)
                    .toList() ??
                existing.documents,
            createdAt: existing.createdAt,
            updatedAt: DateTime.now(),
          );
        }
      }
    } catch (e) {
      _handleError(e);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteTracking(String id) async {
    _setLoading(true);
    notifyListeners();
    try {
      await APIService().deleteTrackingLaporan(id: id);

      if (detailReport != null) {
        detailReport!.data.trackingLaporan.removeWhere(
          (t) => t.id.toString() == id,
        );
      }
    } catch (e) {
      _handleError(e);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> fetchDetailReports(
    String noRegistrasi, {
    bool isAdmin = false,
  }) async {
    notifyListeners();
    _setLoading(true);
    try {
      detailReport = await APIService().getFullReportDetails(
        noRegistrasi,
        isAdmin,
      );

      _setLoading(false);
    } catch (e) {
      _handleError(e);
    } finally {
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void _handleError(e) {
    errorMessage = e.toString();
    isLoading = false;
    notifyListeners();
  }

  // class ReportProvider with ChangeNotifier {
  // Separate lists for each report status
  List<ListLaporanModel> _reportsMasuk = [];
  List<ListLaporanModel> _reportsProses = [];
  List<ListLaporanModel> _reportsSelesai = [];

  // Detail report cache
  final Map<String, DetailResponseModel> _detailReportsCache = {};

  // Loading states
  bool _isLoadingAll = false;
  bool _isLoadingDetail = false;
  String? _errorMessage;

  // Getters
  List<ListLaporanModel> get reportsMasuk => _reportsMasuk;
  List<ListLaporanModel> get reportsProses => _reportsProses;
  List<ListLaporanModel> get reportsSelesai => _reportsSelesai;
  bool get isLoadingAll => _isLoadingAll;
  bool get isLoadingDetail => _isLoadingDetail;
  // String? get errorMessage => _errorMessage;

  // Main method to fetch all reports at once
  Future<void> fetchAllReports() async {
    _isLoadingAll = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final allReports = await APIService().fetchUserReports();

      if (allReports.data != null) {
        _reportsMasuk =
            allReports.data!
                .where((report) => report.status == "Laporan masuk")
                .toList();

        _reportsProses =
            allReports.data!
                .where((report) => report.status == "Diproses")
                .toList();

        _reportsSelesai =
            allReports.data!
                .where((report) => report.status == "Selesai")
                .toList();
      }

      _logger.log("Successfully fetched all reports");
    } catch (e) {
      _errorMessage = "Gagal memuat laporan: ${e.toString()}";
      _logger.log("Error fetching reports $e");
    } finally {
      _isLoadingAll = false;
      notifyListeners();
    }
  }

  // // Get detail report with caching
  // Future<DetailResponseModel?> fetchDetailReports(String noRegistrasi) async {
  //   // Return cached data if available
  //   if (_detailReportsCache.containsKey(noRegistrasi)) {
  //     return _detailReportsCache[noRegistrasi];
  //   }

  //   _isLoadingDetail = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   try {
  //     final detailReport = await APIService().getFullReportDetails(
  //       noRegistrasi,
  //     );
  //     _detailReportsCache[noRegistrasi] = detailReport;
  //     return detailReport;
  //   } catch (e) {
  //     _errorMessage = "Gagal memuat detail laporan";
  //     _logger.log("Error fetching detail report $e");
  //     return null;
  //   } finally {
  //     _isLoadingDetail = false;
  //     notifyListeners();
  //   }
  // }

  // Clear cache when needed
  void clearCache() {
    _detailReportsCache.clear();
    notifyListeners();
  }

  // Refresh all data
  Future<void> refreshAll() async {
    _detailReportsCache.clear();
    await fetchAllReports();
  }

  // Individual status fetchers (optional, can be used for specific refreshes)
  Future<void> fetchReportsMasuk() async {
    try {
      final allReports = await APIService().fetchUserReports();
      _reportsMasuk =
          allReports.data!
              .where((report) => report.status == "Laporan masuk")
              .toList();
    } catch (e) {
      _errorMessage = "Gagal memuat laporan masuk";
    }
    notifyListeners();
  }

  Future<void> fetchReportsProses() async {
    try {
      final allReports = await APIService().fetchUserReports();
      _reportsProses =
          allReports.data!
              .where((report) => report.status == "Diproses")
              .toList();
    } catch (e) {
      _errorMessage = "Gagal memuat laporan proses";
    }
    notifyListeners();
  }

  Future<void> fetchReportsSelesai() async {
    try {
      final allReports = await APIService().fetchUserReports();
      _reportsSelesai =
          allReports.data!
              .where((report) => report.status == "Selesai")
              .toList();
    } catch (e) {
      _errorMessage = "Gagal memuat laporan selesai";
    }
    notifyListeners();
  }
}

// }
