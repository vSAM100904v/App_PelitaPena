import 'package:pa2_kelompok07/model/auth/login_request_model.dart';

enum AppointmentStatus { approved, rejected, cancelled, pendingApproval }

extension AppointmentStatusExtension on AppointmentStatus {
  String get label {
    switch (this) {
      case AppointmentStatus.approved:
        return "Disetujui";
      case AppointmentStatus.rejected:
        return "Ditolak";
      case AppointmentStatus.cancelled:
        return "Dibatalkan";
      case AppointmentStatus.pendingApproval:
        return "Belum disetujui";
    }
  }

  static AppointmentStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case "disetujui":
        return AppointmentStatus.approved;
      case "ditolak":
        return AppointmentStatus.rejected;
      case "dibatalkan":
        return AppointmentStatus.cancelled;
      case "belum disetujui":
        return AppointmentStatus.pendingApproval;
      default:
        throw Exception("Status tidak valid: $status");
    }
  }
}

class AppointmentRequestModel {
  final int id;
  final int? userId;
  final String waktuDimulai;
  final String waktuSelesai;
  final String keperluanKonsultasi;
  final AppointmentStatus status;
  final int? userIdTolakSetujui;
  final String? alasanDitolak;
  final String? alasanDibatalkan;

  AppointmentRequestModel({
    required this.id,
    this.userId,
    required this.waktuDimulai,
    required this.waktuSelesai,
    required this.keperluanKonsultasi,
    required this.status,
    this.userIdTolakSetujui,
    this.alasanDitolak,
    this.alasanDibatalkan,
  });

  factory AppointmentRequestModel.fromJson(Map<String, dynamic> json) {
    return AppointmentRequestModel(
      id: json['id'],
      userId: json['user_id'] != "" ? json['user_id'] : null,
      waktuDimulai: json['waktu_dimulai'],
      waktuSelesai: json['waktu_selesai'],
      keperluanKonsultasi: json['keperluan_konsultasi'],
      status: AppointmentStatusExtension.fromString(json['status']),
      userIdTolakSetujui:
          json['user_id_tolak_setujui'] is int
              ? json['user_id_tolak_setujui']
              : null,
      alasanDitolak:
          json['alasan_ditolak'] != "" ? json['alasan_ditolak'] : null,
      alasanDibatalkan:
          json['alasan_dibatalkan'] != "" ? json['alasan_dibatalkan'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'waktu_dimulai': waktuDimulai,
      'waktu_selesai': waktuSelesai,
      'keperluan_konsultasi': keperluanKonsultasi,
      'status': status.label,
      'user_id_tolak_setujui': userIdTolakSetujui,
      'alasan_ditolak': alasanDitolak,
      'alasan_dibatalkan': alasanDibatalkan,
    };
  }
}
