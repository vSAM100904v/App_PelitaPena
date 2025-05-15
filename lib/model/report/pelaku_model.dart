class PelakuModel {
  final int id;
  final String? noRegistrasi;
  final String? nikPelaku;
  final String? namaPelaku;
  final int? usiaPelaku;
  final String? alamatPelaku;
  final String? alamatDetail;
  final String? jenisKelamin;
  final String? agama;
  final String? noTelepon;
  final String? pendidikan;
  final String? pekerjaan;
  final String? statusPerkawinan;
  final String? kebangsaan;
  final String? hubunganDenganKorban;
  final String? keteranganLainnya;
  final String? dokumentasiPelaku;
  final DateTime createdAt;
  final DateTime updatedAt;

  PelakuModel({
    required this.id,
    this.noRegistrasi,
    this.nikPelaku,
    this.namaPelaku,
    this.usiaPelaku,
    this.alamatPelaku,
    this.alamatDetail,
    this.jenisKelamin,
    this.agama,
    this.noTelepon,
    this.pendidikan,
    this.pekerjaan,
    this.statusPerkawinan,
    this.kebangsaan,
    this.hubunganDenganKorban,
    this.keteranganLainnya,
    this.dokumentasiPelaku,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PelakuModel.fromJson(Map<String, dynamic> json) {
    return PelakuModel(
      id: json['id'] as int? ?? 0,
      noRegistrasi: json['no_registrasi'],
      nikPelaku: json['nik_pelaku'],
      namaPelaku: json['nama_pelaku'],
      usiaPelaku: json['usia_pelaku'] != null ? int.tryParse(json['usia_pelaku'].toString()) : null,
      alamatPelaku: json['alamat_pelaku'],
      alamatDetail: json['alamat_detail'],
      jenisKelamin: json['jenis_kelamin'],
      agama: json['agama'],
      noTelepon: json['no_telepon'],
      pendidikan: json['pendidikan'],
      pekerjaan: json['pekerjaan'],
      statusPerkawinan: json['status_perkawinan'],
      kebangsaan: json['kebangsaan'],
      hubunganDenganKorban: json['hubungan_dengan_korban'],
      keteranganLainnya: json['keterangan_lainnya'],
      dokumentasiPelaku: json['dokumentasi_pelaku'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_registrasi': noRegistrasi,
      'nik_pelaku': nikPelaku,
      'nama_pelaku': namaPelaku,
      'usia_pelaku': usiaPelaku,
      'alamat_pelaku': alamatPelaku,
      'alamat_detail': alamatDetail,
      'jenis_kelamin': jenisKelamin,
      'agama': agama,
      'no_telepon': noTelepon,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
      'status_perkawinan': statusPerkawinan,
      'kebangsaan': kebangsaan,
      'hubungan_dengan_korban': hubunganDenganKorban,
      'keterangan_lainnya': keteranganLainnya,
      'dokumentasi_pelaku': dokumentasiPelaku,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String()
    };
  }
}
