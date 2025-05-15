class CountReportStatus {
  final int laporanMasuk;
  final int laporanDilihat;
  final int laporanDiproses;
  final int laporanSelesai;
  final int laporanDibatalkan;

  CountReportStatus({
    required this.laporanMasuk,
    required this.laporanDilihat,
    required this.laporanDiproses,
    required this.laporanSelesai,
    required this.laporanDibatalkan,
  });

  factory CountReportStatus.fromJson(Map<String, dynamic> json) {
    return CountReportStatus(
      laporanMasuk: json['laporanMasuk'] as int,
      laporanDilihat: json['laporanDilihat'] as int,
      laporanDiproses: json['laporanDiproses'] as int,
      laporanSelesai: json['laporanSelesai'] as int,
      laporanDibatalkan: json['laporanDibatalkan'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'laporanMasuk': laporanMasuk,
      'laporanDilihat': laporanDilihat,
      'laporanDiproses': laporanDiproses,
      'laporanSelesai': laporanSelesai,
      'laporanDibatalkan': laporanDibatalkan,
    };
  }
}
