class KorbanResponseModel {
  int code;
  String status;
  String message;
  KorbanModel data;

  KorbanResponseModel({required this.code, required this.status, required this.message, required this.data});

  factory KorbanResponseModel.fromJson(Map<String, dynamic> json) {
    return KorbanResponseModel(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: KorbanModel.fromJson(json['Data']),
    );
  }
}

class KorbanModel {
  final int id;
  final String? noRegistrasi;
  final String? nikKorban;
  final String? namaKorban;
  final int? usiaKorban;
  final String? alamatKorban;
  final String? alamatDetail;
  final String? jenisKelamin;
  final String? agama;
  final String? noTelepon;
  final String? pendidikan;
  final String? pekerjaan;
  final String? statusPerkawinan;
  final String? kebangsaan;
  final String? hubunganDenganPelaku;
  final String? keteranganLainnya;
  final String? dokumentasiKorban;
  final DateTime createdAt;
  final DateTime updatedAt;

  KorbanModel({
    required this.id,
    this.noRegistrasi,
    this.nikKorban,
    this.namaKorban,
    this.usiaKorban,
    this.alamatKorban,
    this.alamatDetail,
    this.jenisKelamin,
    this.agama,
    this.noTelepon,
    this.pendidikan,
    this.pekerjaan,
    this.statusPerkawinan,
    this.kebangsaan,
    this.hubunganDenganPelaku,
    this.keteranganLainnya,
    this.dokumentasiKorban,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KorbanModel.fromJson(Map<String, dynamic> json) {
    return KorbanModel(
      id: json['id'] as int? ?? 0,
      noRegistrasi: json['no_registrasi'],
      nikKorban: json['nik_korban'],
      namaKorban: json['nama_korban'],
      usiaKorban: json['usia_korban'] != null ? int.tryParse(json['usia_korban'].toString()) : null,
      alamatKorban: json['alamat_korban'],
      alamatDetail: json['alamat_detail'],
      jenisKelamin: json['jenis_kelamin'],
      agama: json['agama'],
      noTelepon: json['no_telepon'],
      pendidikan: json['pendidikan'],
      pekerjaan: json['pekerjaan'],
      statusPerkawinan: json['status_perkawinan'],
      kebangsaan: json['kebangsaan'],
      hubunganDenganPelaku: json['hubungan_dengan_pelaku'],
      keteranganLainnya: json['keterangan_lainnya'],
      dokumentasiKorban: json['dokumentasi_korban'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_registrasi': noRegistrasi,
      'nik_korban': nikKorban,
      'nama_korban': namaKorban,
      'usia_korban': usiaKorban,
      'alamat_korban': alamatKorban,
      'alamat_detail': alamatDetail,
      'jenis_kelamin': jenisKelamin,
      'agama': agama,
      'no_telepon': noTelepon,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
      'status_perkawinan': statusPerkawinan,
      'kebangsaan': kebangsaan,
      'hubungan_dengan_pelaku': hubunganDenganPelaku,
      'keterangan_lainnya': keteranganLainnya,
      'dokumentasi_korban': dokumentasiKorban,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String()
    };
  }
}
