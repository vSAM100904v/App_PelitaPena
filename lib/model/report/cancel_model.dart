class ResponCancelModel {
  final int code;
  final String status;
  final String message;
  final DataModel data;

  ResponCancelModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ResponCancelModel.fromJson(Map<String, dynamic> json) {
    return ResponCancelModel(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: DataModel.fromJson(json['Data']),
    );
  }
}

class DataModel {
  final String alasanDibatalkan;
  final String noRegistrasi;
  final String status;
  final DateTime updatedAt;
  final DateTime waktuDibatalkan;

  DataModel({
    required this.alasanDibatalkan,
    required this.noRegistrasi,
    required this.status,
    required this.updatedAt,
    required this.waktuDibatalkan,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      alasanDibatalkan: json['alasan_dibatalkan'],
      noRegistrasi: json['no_registrasi'],
      status: json['status'],
      updatedAt: DateTime.parse(json['updated_at']),
      waktuDibatalkan: DateTime.parse(json['waktu_dibatalkan']),
    );
  }
}
