class ReportRequestModel {
  final String alamatDetailTkp;
  final String alamatTkp;
  final String createdAt;
  final Dokumentasi dokumentasi;
  final int kategoriKekerasanId;
  final String kategoriLokasiKasus;
  final String kronologisKasus;
  final String noRegistrasi;
  final String tanggalKejadian;
  final String tanggalPelaporan;
  final String updatedAt;
  final int userId;

  ReportRequestModel({
    required this.alamatDetailTkp,
    required this.alamatTkp,
    required this.createdAt,
    required this.dokumentasi,
    required this.kategoriKekerasanId,
    required this.kategoriLokasiKasus,
    required this.kronologisKasus,
    required this.noRegistrasi,
    required this.tanggalKejadian,
    required this.tanggalPelaporan,
    required this.updatedAt,
    required this.userId,
  });

  factory ReportRequestModel.fromJson(Map<String, dynamic> json) {
    return ReportRequestModel(
      alamatDetailTkp: json['alamat_detail_tkp'],
      alamatTkp: json['alamat_tkp'],
      createdAt: json['created_at'],
      dokumentasi: Dokumentasi.fromJson(json['dokumentasi']),
      kategoriKekerasanId: json['kategori_kekerasan_id'],
      kategoriLokasiKasus: json['kategori_lokasi_kasus'],
      kronologisKasus: json['kronologis_kasus'],
      noRegistrasi: json['no_registrasi'],
      tanggalKejadian: json['tanggal_kejadian'],
      tanggalPelaporan: json['tanggal_pelaporan'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alamat_detail_tkp': alamatDetailTkp,
      'alamat_tkp': alamatTkp,
      'created_at': createdAt,
      'dokumentasi': dokumentasi.toJson(),
      'kategori_kekerasan_id': kategoriKekerasanId,
      'kategori_lokasi_kasus': kategoriLokasiKasus,
      'kronologis_kasus': kronologisKasus,
      'no_registrasi': noRegistrasi,
      'tanggal_kejadian': tanggalKejadian,
      'tanggal_pelaporan': tanggalPelaporan,
      'updated_at': updatedAt,
      'user_id': userId,
    };
  }
}

class Dokumentasi {
  List<String> urls;
  Dokumentasi({required this.urls});

  factory Dokumentasi.fromJson(Map<String, dynamic> json) {
    print('Parsing Dokumentasi: $json');
    final urlsData = json['urls'];
    List<String> urls;
    if (urlsData == null) {
      urls = [];
    } else if (urlsData is String) {
      urls = [urlsData];
    } else if (urlsData is Iterable) {
      urls = List<String>.from(urlsData);
    } else {
      urls = [];
    }
    return Dokumentasi(urls: urls);
  }

  Map<String, dynamic> toJson() => {'urls': urls};
}
