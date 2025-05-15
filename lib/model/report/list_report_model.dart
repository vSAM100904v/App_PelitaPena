import 'package:pa2_kelompok07/model/report/report_category_model.dart';
import 'package:pa2_kelompok07/model/report/report_request_model.dart';

import 'dart:developer' as developer; // Untuk logging
import 'package:pa2_kelompok07/model/report/report_category_model.dart';
import 'package:pa2_kelompok07/model/report/report_request_model.dart';

// class ListLaporanModel {
//   String alamatDetailTkp;
//   String alamatTkp;
//   String alasanDibatalkan;
//   DateTime createdAt;
//   Dokumentasi dokumentasi;
//   int kategoriKekerasanId;
//   String kategoriLokasiKasus;
//   String kronologisKasus;
//   String noRegistrasi;
//   String status;
//   DateTime tanggalKejadian;
//   DateTime tanggalPelaporan;
//   DateTime updatedAt;
//   int userId;
//   int? useridMelihat;
//   ViolenceCategory violenceCategoryDetail;
//   String? waktuDibatalkan;
//   String? waktuDilihat;
//   String? waktuDiproses;

//   ListLaporanModel({
//     required this.alamatDetailTkp,
//     required this.alamatTkp,
//     required this.alasanDibatalkan,
//     required this.createdAt,
//     required this.dokumentasi,
//     required this.kategoriKekerasanId,
//     required this.kategoriLokasiKasus,
//     required this.kronologisKasus,
//     required this.noRegistrasi,
//     required this.status,
//     required this.tanggalKejadian,
//     required this.tanggalPelaporan,
//     required this.updatedAt,
//     required this.userId,
//     this.useridMelihat,
//     required this.violenceCategoryDetail,
//     this.waktuDibatalkan,
//     this.waktuDilihat,
//     this.waktuDiproses,
//   });

//   Map<String, dynamic> toJson() => {
//     'alamat_detail_tkp': alamatDetailTkp,
//     'alamat_tkp': alamatTkp,
//     'alasan_dibatalkan': alasanDibatalkan,
//     'created_at': createdAt.toIso8601String(),
//     'dokumentasi': dokumentasi.toJson(),
//     'kategori_kekerasan_id': kategoriKekerasanId,
//     'kategori_lokasi_kasus': kategoriLokasiKasus,
//     'kronologis_kasus': kronologisKasus,
//     'no_registrasi': noRegistrasi,
//     'status': status,
//     'tanggal_kejadian': tanggalKejadian.toIso8601String(),
//     'tanggal_pelaporan': tanggalPelaporan.toIso8601String(),
//     'updated_at': updatedAt.toIso8601String(),
//     'user_id': userId,
//     'userid_melihat': useridMelihat,
//     'violence_category': violenceCategoryDetail.toJson(),
//     'waktu_dibatalkan': waktuDibatalkan,
//     'waktu_dilihat': waktuDilihat,
//     'waktu_diproses': waktuDiproses,
//   };

//   factory ListLaporanModel.fromJson(Map<String, dynamic> json) {
//     // Logging untuk field yang null atau kosong
//     void logIfEmpty(String fieldName, dynamic value) {
//       if (value == null || (value is String && value.isEmpty)) {
//         developer.log('Field "$fieldName" kosong atau null: $value');
//       }
//     }

//     // Default DateTime jika parsing gagal
//     final defaultDateTime = DateTime(1970, 1, 1);

//     // Cek dan log setiap field
//     logIfEmpty('alamat_detail_tkp', json['alamat_detail_tkp']);
//     logIfEmpty('alamat_tkp', json['alamat_tkp']);
//     logIfEmpty('alasan_dibatalkan', json['alasan_dibatalkan']);
//     logIfEmpty('created_at', json['created_at']);
//     logIfEmpty('dokumentasi', json['dokumentasi']);
//     logIfEmpty('kategori_kekerasan_id', json['kategori_kekerasan_id']);
//     logIfEmpty('kategori_lokasi_kasus', json['kategori_lokasi_kasus']);
//     logIfEmpty('kronologis_kasus', json['kronologis_kasus']);
//     logIfEmpty('no_registrasi', json['no_registrasi']);
//     logIfEmpty('status', json['status']);
//     logIfEmpty('tanggal_kejadian', json['tanggal_kejadian']);
//     logIfEmpty('tanggal_pelaporan', json['tanggal_pelaporan']);
//     logIfEmpty('updated_at', json['updated_at']);
//     logIfEmpty('user_id', json['user_id']);
//     logIfEmpty('userid_melihat', json['userid_melihat']);
//     logIfEmpty('violence_category', json['violence_category']);
//     logIfEmpty('waktu_dibatalkan', json['waktu_dibatalkan']);
//     logIfEmpty('waktu_dilihat', json['waktu_dilihat']);
//     logIfEmpty('waktu_diproses', json['waktu_diproses']);

//     return ListLaporanModel(
//       alamatDetailTkp:
//           json['alamat_detail_tkp'] as String? ?? 'Tidak diketahui',
//       alamatTkp: json['alamat_tkp'] as String? ?? 'Tidak diketahui',
//       alasanDibatalkan: json['alasan_dibatalkan'] as String? ?? '',
//       createdAt:
//           DateTime.tryParse(json['created_at'] as String? ?? '') ??
//           defaultDateTime,
//       dokumentasi:
//           json['dokumentasi'] != null
//               ? Dokumentasi.fromJson(
//                 json['dokumentasi'] as Map<String, dynamic>,
//               )
//               : Dokumentasi(urls: []), // Default jika null
//       kategoriKekerasanId: json['kategori_kekerasan_id'] as int? ?? 0,
//       kategoriLokasiKasus:
//           json['kategori_lokasi_kasus'] as String? ?? 'Tidak diketahui',
//       kronologisKasus:
//           json['kronologis_kasus'] as String? ?? 'Tidak ada kronologi',
//       noRegistrasi:
//           json['no_registrasi'] as String? ?? 'Tidak ada nomor registrasi',
//       status: json['status'] as String? ?? 'Tidak diketahui',
//       tanggalKejadian:
//           DateTime.tryParse(json['tanggal_kejadian'] as String? ?? '') ??
//           defaultDateTime,
//       tanggalPelaporan:
//           DateTime.tryParse(json['tanggal_pelaporan'] as String? ?? '') ??
//           defaultDateTime,
//       updatedAt:
//           DateTime.tryParse(json['updated_at'] as String? ?? '') ??
//           defaultDateTime,
//       userId: json['user_id'] as int? ?? 0,
//       useridMelihat: json['userid_melihat'] as int?,
//       violenceCategoryDetail:
//           json['violence_category_detail'] != null
//               ? ViolenceCategory.fromJson(
//                 json['violence_category_detail'] as Map<String, dynamic>,
//               )
//               : ViolenceCategory(
//                 id: 0,
//                 categoryName: 'Kategori tidak diketahui',
//                 image: '',
//                 createdAt: defaultDateTime.toIso8601String(),
//                 updatedAt: defaultDateTime.toIso8601String(),
//               ),
//       waktuDibatalkan: json['waktu_dibatalkan'] as String?,
//       waktuDilihat: json['waktu_dilihat'] as String?,
//       waktuDiproses: json['waktu_diproses'] as String?,
//     );
//   }

//   // Metode copyWith
//   ListLaporanModel copyWith({
//     String? alamatDetailTkp,
//     String? alamatTkp,
//     String? alasanDibatalkan,
//     DateTime? createdAt,
//     Dokumentasi? dokumentasi,
//     int? kategoriKekerasanId,
//     String? kategoriLokasiKasus,
//     String? kronologisKasus,
//     String? noRegistrasi,
//     String? status,
//     DateTime? tanggalKejadian,
//     DateTime? tanggalPelaporan,
//     DateTime? updatedAt,
//     int? userId,
//     int? useridMelihat,
//     ViolenceCategory? violenceCategoryDetail,
//     String? waktuDibatalkan,
//     String? waktuDilihat,
//     String? waktuDiproses,
//   }) {
//     return ListLaporanModel(
//       alamatDetailTkp: alamatDetailTkp ?? this.alamatDetailTkp,
//       alamatTkp: alamatTkp ?? this.alamatTkp,
//       alasanDibatalkan: alasanDibatalkan ?? this.alasanDibatalkan,
//       createdAt: createdAt ?? this.createdAt,
//       dokumentasi: dokumentasi ?? this.dokumentasi,
//       kategoriKekerasanId: kategoriKekerasanId ?? this.kategoriKekerasanId,
//       kategoriLokasiKasus: kategoriLokasiKasus ?? this.kategoriLokasiKasus,
//       kronologisKasus: kronologisKasus ?? this.kronologisKasus,
//       noRegistrasi: noRegistrasi ?? this.noRegistrasi,
//       status: status ?? this.status,
//       tanggalKejadian: tanggalKejadian ?? this.tanggalKejadian,
//       tanggalPelaporan: tanggalPelaporan ?? this.tanggalPelaporan,
//       updatedAt: updatedAt ?? this.updatedAt,
//       userId: userId ?? this.userId,
//       useridMelihat: useridMelihat ?? this.useridMelihat,
//       violenceCategoryDetail:
//           violenceCategoryDetail ?? this.violenceCategoryDetail,
//       waktuDibatalkan: waktuDibatalkan ?? this.waktuDibatalkan,
//       waktuDilihat: waktuDilihat ?? this.waktuDilihat,
//       waktuDiproses: waktuDiproses ?? this.waktuDiproses,
//     );
//   }
// }

// class ResponseModel {
//   int code;
//   String status;
//   String message;
//   List<ListLaporanModel> data;

//   ResponseModel({
//     required this.code,
//     required this.status,
//     required this.message,
//     required this.data,
//   });

//   factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
//     code: json['code'],
//     status: json['status'],
//     message: json['message'],
//     data: List<ListLaporanModel>.from(
//       json['Data'].map((x) => ListLaporanModel.fromJson(x)),
//     ),
//   );

//   Map<String, dynamic> toJson() => {
//     'code': code,
//     'status': status,
//     'message': message,
//     'Data': List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }

class ListLaporanModel {
  String alamatDetailTkp;
  String alamatTkp;
  String alasanDibatalkan;
  DateTime createdAt;
  Dokumentasi dokumentasi;
  int kategoriKekerasanId;
  String kategoriLokasiKasus;
  String kronologisKasus;
  String noRegistrasi;
  String status;
  DateTime tanggalKejadian;
  DateTime tanggalPelaporan;
  DateTime updatedAt;
  int userId;
  int? useridMelihat;
  ViolenceCategory violenceCategoryDetail;
  String? waktuDibatalkan;
  String? waktuDilihat;
  String? waktuDiproses;

  ListLaporanModel({
    required this.alamatDetailTkp,
    required this.alamatTkp,
    required this.alasanDibatalkan,
    required this.createdAt,
    required this.dokumentasi,
    required this.kategoriKekerasanId,
    required this.kategoriLokasiKasus,
    required this.kronologisKasus,
    required this.noRegistrasi,
    required this.status,
    required this.tanggalKejadian,
    required this.tanggalPelaporan,
    required this.updatedAt,
    required this.userId,
    this.useridMelihat,
    required this.violenceCategoryDetail,
    this.waktuDibatalkan,
    this.waktuDilihat,
    this.waktuDiproses,
  });

  Map<String, dynamic> toJson() => {
    'alamat_detail_tkp': alamatDetailTkp,
    'alamat_tkp': alamatTkp,
    'alasan_dibatalkan': alasanDibatalkan,
    'created_at': createdAt.toIso8601String(),
    'dokumentasi': dokumentasi.toJson(),
    'kategori_kekerasan_id': kategoriKekerasanId,
    'kategori_lokasi_kasus': kategoriLokasiKasus,
    'kronologis_kasus': kronologisKasus,
    'no_registrasi': noRegistrasi,
    'status': status,
    'tanggal_kejadian': tanggalKejadian.toIso8601String(),
    'tanggal_pelaporan': tanggalPelaporan.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'user_id': userId,
    'userid_melihat': useridMelihat,
    'violence_category_detail': violenceCategoryDetail.toJson(),
    'waktu_dibatalkan': waktuDibatalkan,
    'waktu_dilihat': waktuDilihat,
    'waktu_diproses': waktuDiproses,
  };

  factory ListLaporanModel.fromJson(Map<String, dynamic> json) {
    developer.log('Parsing ListLaporanModel: $json');

    void logIfEmpty(String fieldName, dynamic value) {
      if (value == null || (value is String && value.isEmpty)) {
        developer.log('Field "$fieldName" kosong atau null: $value');
      }
    }

    final defaultDateTime = DateTime(1970, 1, 1);

    logIfEmpty('alamat_detail_tkp', json['alamat_detail_tkp']);
    logIfEmpty('alamat_tkp', json['alamat_tkp']);
    logIfEmpty('alasan_dibatalkan', json['alasan_dibatalkan']);
    logIfEmpty('created_at', json['created_at']);
    logIfEmpty('dokumentasi', json['dokumentasi']);
    logIfEmpty('kategori_kekerasan_id', json['kategori_kekerasan_id']);
    logIfEmpty('kategori_lokasi_kasus', json['kategori_lokasi_kasus']);
    logIfEmpty('kronologis_kasus', json['kronologis_kasus']);
    logIfEmpty('no_registrasi', json['no_registrasi']);
    logIfEmpty('status', json['status']);
    logIfEmpty('tanggal_kejadian', json['tanggal_kejadian']);
    logIfEmpty('tanggal_pelaporan', json['tanggal_pelaporan']);
    logIfEmpty('updated_at', json['updated_at']);
    logIfEmpty('user_id', json['user_id']);
    logIfEmpty('userid_melihat', json['userid_melihat']);
    logIfEmpty('violence_category_detail', json['violence_category_detail']);
    logIfEmpty('waktu_dibatalkan', json['waktu_dibatalkan']);
    logIfEmpty('waktu_dilihat', json['waktu_dilihat']);
    logIfEmpty('waktu_diproses', json['waktu_diproses']);

    return ListLaporanModel(
      alamatDetailTkp:
          json['alamat_detail_tkp'] as String? ?? 'Tidak diketahui',
      alamatTkp: json['alamat_tkp'] as String? ?? 'Tidak diketahui',
      alasanDibatalkan: json['alasan_dibatalkan'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          defaultDateTime,
      dokumentasi:
          json['dokumentasi'] != null
              ? Dokumentasi.fromJson(
                json['dokumentasi'] as Map<String, dynamic>,
              )
              : Dokumentasi(urls: []),
      kategoriKekerasanId: json['kategori_kekerasan_id'] as int? ?? 0,
      kategoriLokasiKasus:
          json['kategori_lokasi_kasus'] as String? ?? 'Tidak diketahui',
      kronologisKasus:
          json['kronologis_kasus'] as String? ?? 'Tidak ada kronologi',
      noRegistrasi:
          json['no_registrasi'] as String? ?? 'Tidak ada nomor registrasi',
      status: json['status'] as String? ?? 'Tidak diketahui',
      tanggalKejadian:
          DateTime.tryParse(json['tanggal_kejadian'] as String? ?? '') ??
          defaultDateTime,
      tanggalPelaporan:
          DateTime.tryParse(json['tanggal_pelaporan'] as String? ?? '') ??
          defaultDateTime,
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          defaultDateTime,
      userId: json['user_id'] as int? ?? 0,
      useridMelihat: json['userid_melihat'] as int?,
      violenceCategoryDetail:
          json['violence_category_detail'] != null
              ? ViolenceCategory.fromJson(
                json['violence_category_detail'] as Map<String, dynamic>,
              )
              : ViolenceCategory(
                id: 0,
                categoryName: 'Kategori tidak diketahui',
                image: '',
                createdAt: defaultDateTime.toIso8601String(),
                updatedAt: defaultDateTime.toIso8601String(),
              ),
      waktuDibatalkan: json['waktu_dibatalkan'] as String?,
      waktuDilihat: json['waktu_dilihat'] as String?,
      waktuDiproses: json['waktu_diproses'] as String?,
    );
  }

  ListLaporanModel copyWith({
    String? alamatDetailTkp,
    String? alamatTkp,
    String? alasanDibatalkan,
    DateTime? createdAt,
    Dokumentasi? dokumentasi,
    int? kategoriKekerasanId,
    String? kategoriLokasiKasus,
    String? kronologisKasus,
    String? noRegistrasi,
    String? status,
    DateTime? tanggalKejadian,
    DateTime? tanggalPelaporan,
    DateTime? updatedAt,
    int? userId,
    int? useridMelihat,
    ViolenceCategory? violenceCategoryDetail,
    String? waktuDibatalkan,
    String? waktuDilihat,
    String? waktuDiproses,
  }) {
    return ListLaporanModel(
      alamatDetailTkp: alamatDetailTkp ?? this.alamatDetailTkp,
      alamatTkp: alamatTkp ?? this.alamatTkp,
      alasanDibatalkan: alasanDibatalkan ?? this.alasanDibatalkan,
      createdAt: createdAt ?? this.createdAt,
      dokumentasi: dokumentasi ?? this.dokumentasi,
      kategoriKekerasanId: kategoriKekerasanId ?? this.kategoriKekerasanId,
      kategoriLokasiKasus: kategoriLokasiKasus ?? this.kategoriLokasiKasus,
      kronologisKasus: kronologisKasus ?? this.kronologisKasus,
      noRegistrasi: noRegistrasi ?? this.noRegistrasi,
      status: status ?? this.status,
      tanggalKejadian: tanggalKejadian ?? this.tanggalKejadian,
      tanggalPelaporan: tanggalPelaporan ?? this.tanggalPelaporan,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      useridMelihat: useridMelihat ?? this.useridMelihat,
      violenceCategoryDetail:
          violenceCategoryDetail ?? this.violenceCategoryDetail,
      waktuDibatalkan: waktuDibatalkan ?? this.waktuDibatalkan,
      waktuDilihat: waktuDilihat ?? this.waktuDilihat,
      waktuDiproses: waktuDiproses ?? this.waktuDiproses,
    );
  }
}

class ResponseModel {
  int code;
  String status;
  String message;
  List<ListLaporanModel> data;

  ResponseModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    developer.log('Raw JSON Response: $json');
    final dataList = json['Data']; // Tangani kunci 'data' atau 'Data'
    return ResponseModel(
      code: json['code'] as int? ?? 0,
      status: json['status'] as String? ?? 'unknown',
      message: json['message'] as String? ?? '',
      data:
          dataList is List
              ? List<ListLaporanModel>.from(
                dataList.map(
                  (x) => ListLaporanModel.fromJson(x as Map<String, dynamic>),
                ),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'status': status,
    'message': message,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
