import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/model/report/tracking_report_model.dart';

class MockUp {
  static final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Laporan masuk tentang kasus kekerasan di Desa Silalahi',
      'sender': 'Oleh pihak DPMDPPA',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.report,
      'color': Colors.red,
      'isRead': false,
    },
    {
      'title': 'Sosialisasi Pencegahan Kekerasan Kabupaten Toba',
      'sender': 'Oleh Dinas Sosial Kabupaten',
      'time': DateTime.now().subtract(const Duration(hours: 3)),
      'icon': Icons.campaign,
      'color': Colors.blue,
      'isRead': true,
    },
    {
      'title': 'Pertemuan rutin bulanan tim penanganan kasus',
      'sender': 'Oleh Koordinator Tim',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.event,
      'color': Colors.green,
      'isRead': false,
    },
    {
      'title': 'Update data korban untuk laporan triwulan',
      'sender': 'Oleh Admin Sistem',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'icon': Icons.data_usage,
      'color': Colors.orange,
      'isRead': true,
    },
    {
      'title': 'Pelatihan konseling trauma pasca kekerasan',
      'sender': 'Oleh Psikolog DPMDPPA',
      'time': DateTime.now().subtract(const Duration(days: 7)),
      'icon': Icons.school,
      'color': Colors.purple,
      'isRead': true,
    },
  ];
  static List<TrackingLaporanModel> dummyTrackingLaporanData = [
    TrackingLaporanModel(
      id: 1,
      noRegistrasi: 'REG123456',
      keterangan: 'Laporan pertama mengenai masalah teknis.',
      documents: [
        Config.fallbackImage,
        'https://example.com/documents/doc2.pdf',
      ],
      createdAt: DateTime.parse('2023-01-01T10:00:00Z'),
      updatedAt: DateTime.parse('2023-01-02T12:00:00Z'),
    ),
    TrackingLaporanModel(
      id: 2,
      noRegistrasi: 'REG123457',
      keterangan: 'Laporan kedua mengenai masalah keuangan.',
      documents: ['https://example.com/documents/doc3.pdf'],
      createdAt: DateTime.parse('2023-02-01T11:00:00Z'),
      updatedAt: DateTime.parse('2023-02-02T13:00:00Z'),
    ),
    TrackingLaporanModel(
      id: 3,
      noRegistrasi: 'REG123458',
      keterangan: 'Laporan ketiga mengenai masalah operasional.',
      documents: [
        'https://example.com/documents/doc4.pdf',
        Config.fallbackImage,
        'https://example.com/documents/doc6.pdf',
      ],
      createdAt: DateTime.parse('2023-03-01T09:30:00Z'),
      updatedAt: DateTime.parse('2023-03-02T15:45:00Z'),
    ),
    TrackingLaporanModel(
      id: 4,
      noRegistrasi: 'REG123459',
      keterangan: 'Laporan keempat mengenai masalah sumber daya manusia.',
      documents: [],
      createdAt: DateTime.parse('2023-04-01T08:15:00Z'),
      updatedAt: DateTime.parse('2023-04-02T10:30:00Z'),
    ),
    TrackingLaporanModel(
      id: 5,
      noRegistrasi: 'REG123460',
      keterangan: 'Laporan kelima mengenai masalah lingkungan.',
      documents: ['https://example.com/documents/doc7.pdf'],
      createdAt: DateTime.parse('2023-05-01T14:00:00Z'),
      updatedAt: DateTime.parse('2023-05-02T16:00:00Z'),
    ),
  ];
}
