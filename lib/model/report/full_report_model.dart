import 'package:pa2_kelompok07/model/report/report_category_model.dart';
import 'package:pa2_kelompok07/model/report/report_request_model.dart';
import 'package:pa2_kelompok07/model/report/tracking_report_model.dart';
import '../auth/login_request_model.dart';

class DetailResponseModel {
  final int code;
  final String status;
  final String message;
  final ReportDetail data;

  DetailResponseModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory DetailResponseModel.fromJson(Map<String, dynamic> json) {
    // Print JSON yang diterima untuk debugging
    print('Received JSON: $json');

    // Mengambil data dari JSON dan membuat objek ReportDetail
    final reportDetail = ReportDetail.fromJson(json['Data'] ?? {});

    // Print detail tracking setelah diubah menjadi objek
    print('Tracking Detail: ${reportDetail.trackingLaporan}');

    return DetailResponseModel(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: reportDetail,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'Data': data.toJson(),
    };
  }
}

class ReportDetail {
  final String noRegistrasi;
  final User user;
  final int userId;
  final ViolenceCategory violenceCategory;
  final int kategoriKekerasanId;
  final DateTime tanggalPelaporan;
  final DateTime tanggalKejadian;
  final String kategoriLokasiKasus;
  final String alamatTkp;
  final String alamatDetailTkp;
  final String kronologisKasus;
  final String status;
  final String? alasanDibatalkan;
  final DateTime? waktuDilihat;
  final int? useridMelihat;
  final DateTime? waktuDiproses;
  final DateTime? waktuDibatalkan;
  final Dokumentasi dokumentasi;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TrackingLaporanModel> trackingLaporan;
  final List<dynamic> pelaku;
  final List<dynamic> korban;
  final User? userMelihat;

  ReportDetail({
    required this.noRegistrasi,
    required this.user,
    required this.userId,
    required this.violenceCategory,
    required this.kategoriKekerasanId,
    required this.tanggalPelaporan,
    required this.tanggalKejadian,
    required this.kategoriLokasiKasus,
    required this.alamatTkp,
    required this.alamatDetailTkp,
    required this.kronologisKasus,
    required this.status,
    this.alasanDibatalkan,
    this.waktuDilihat,
    this.useridMelihat,
    this.waktuDiproses,
    this.waktuDibatalkan,
    required this.dokumentasi,
    required this.createdAt,
    required this.updatedAt,
    required this.trackingLaporan,
    required this.pelaku,
    required this.korban,
    this.userMelihat,
  });

  factory ReportDetail.fromJson(Map<String, dynamic> json) {
    return ReportDetail(
      noRegistrasi: json['no_registrasi'] ?? '',
      user: User.fromJson(json['User'] ?? {}),
      userId: json['user_id'] ?? 0,
      violenceCategory: ViolenceCategory.fromJson(
        json['ViolenceCategory'] ?? {},
      ),
      kategoriKekerasanId: json['kategori_kekerasan_id'] ?? 0,
      tanggalPelaporan: DateTime.parse(
        json['tanggal_pelaporan'] ?? DateTime.now().toIso8601String(),
      ),
      tanggalKejadian: DateTime.parse(
        json['tanggal_kejadian'] ?? DateTime.now().toIso8601String(),
      ),
      kategoriLokasiKasus: json['kategori_lokasi_kasus'] ?? '',
      alamatTkp: json['alamat_tkp'] ?? '',
      alamatDetailTkp: json['alamat_detail_tkp'] ?? '',
      kronologisKasus: json['kronologis_kasus'] ?? '',
      status: json['status'] ?? '',
      alasanDibatalkan: json['alasan_dibatalkan'] ?? '',
      waktuDilihat:
          json['waktu_dilihat'] != null
              ? DateTime.parse(json['waktu_dilihat'])
              : null,
      useridMelihat: json['userid_melihat'] ?? 0,
      waktuDiproses:
          json['waktu_diproses'] != null
              ? DateTime.parse(json['waktu_diproses'])
              : null,
      waktuDibatalkan:
          json['waktu_dibatalkan'] != null
              ? DateTime.parse(json['waktu_dibatalkan'])
              : null,
      dokumentasi: Dokumentasi.fromJson(json['dokumentasi'] ?? {}),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      trackingLaporan:
          json['tracking_laporan'] != null
              ? (json['tracking_laporan'] as List)
                  .map((item) => TrackingLaporanModel.fromJson(item))
                  .toList()
              : [],
      pelaku: json['pelaku'] != null ? List<dynamic>.from(json['pelaku']) : [],
      korban: json['korban'] != null ? List<dynamic>.from(json['korban']) : [],
      userMelihat:
          json['user_melihat'] != null
              ? User.fromJson(json['user_melihat'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_registrasi': noRegistrasi,
      'User': user.toJson(),
      'user_id': userId,
      'ViolenceCategory': violenceCategory.toJson(),
      'kategori_kekerasan_id': kategoriKekerasanId,
      'tanggal_pelaporan': tanggalPelaporan.toIso8601String(),
      'tanggal_kejadian': tanggalKejadian.toIso8601String(),
      'kategori_lokasi_kasus': kategoriLokasiKasus,
      'alamat_tkp': alamatTkp,
      'alamat_detail_tkp': alamatDetailTkp,
      'kronologis_kasus': kronologisKasus,
      'status': status,
      'alasan_dibatalkan': alasanDibatalkan,
      'waktu_dilihat': waktuDilihat?.toIso8601String(),
      'userid_melihat': useridMelihat,
      'waktu_diproses': waktuDiproses?.toIso8601String(),
      'waktu_dibatalkan': waktuDibatalkan?.toIso8601String(),
      'dokumentasi': dokumentasi.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'tracking_laporan': trackingLaporan.map((item) => item.toJson()).toList(),
      'pelaku': pelaku,
      'korban': korban,
      'user_melihat': userMelihat?.toJson(),
    };
  }

  @override
  String toString() {
    return '''
ReportDetail(
  noRegistrasi: $noRegistrasi,
  user: ${user.toString()},
  userId: $userId,
  violenceCategory: ${violenceCategory.toString()},
  kategoriKekerasanId: $kategoriKekerasanId,
  tanggalPelaporan: $tanggalPelaporan,
  tanggalKejadian: $tanggalKejadian,
  kategoriLokasiKasus: $kategoriLokasiKasus,
  alamatTkp: $alamatTkp,
  alamatDetailTkp: $alamatDetailTkp,
  kronologisKasus: $kronologisKasus,
  status: $status,
  alasanDibatalkan: $alasanDibatalkan,
  waktuDilihat: $waktuDilihat,
  useridMelihat: $useridMelihat,
  waktuDiproses: $waktuDiproses,
  waktuDibatalkan: $waktuDibatalkan,
  dokumentasi: ${dokumentasi.toString()},
  createdAt: $createdAt,
  updatedAt: $updatedAt,
  trackingLaporan: [${trackingLaporan.map((e) => e.toString()).join(', ')}],
  pelaku: $pelaku,
  korban: $korban,
  userMelihat: ${userMelihat?.toString()}
)
''';
  }
}
