class TrackingLaporanModel {
  final int id;
  final String noRegistrasi;
  final String keterangan;
  final List<String> documents;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrackingLaporanModel({
    required this.id,
    required this.noRegistrasi,
    required this.keterangan,
    required this.documents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrackingLaporanModel.fromJson(Map<String, dynamic> json) {
    List<String> documentUrls = [];
    if (json['document'] != null && json['document']['urls'] != null) {
      documentUrls = (json['document']['urls'] as List).map((url) => url.toString()).toList();
    }

    return TrackingLaporanModel(
      id: json['id'] as int? ?? 0,
      noRegistrasi: json['no_registrasi'] as String? ?? '',
      keterangan: json['keterangan'] as String? ?? '',
      documents: documentUrls,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_registrasi': noRegistrasi,
      'keterangan': keterangan,
      'document': {
        'urls': documents,
      },
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String()
    };
  }
}
