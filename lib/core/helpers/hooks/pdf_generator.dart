import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pa2_kelompok07/core/services/pdf_service.dart';
import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import 'package:pa2_kelompok07/provider/admin_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Ekstensi untuk DocumentManagerService
extension PdfReportGenerator on DocumentManagerService {
  // Styling custom untuk PDF
  static pw.TextStyle _headerStyle = pw.TextStyle(
    fontSize: 16,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.blue900,
  );

  static pw.TextStyle _titleStyle = pw.TextStyle(
    fontSize: 14,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.black,
  );

  static pw.TextStyle _contentStyle = pw.TextStyle(
    fontSize: 12,
    color: PdfColors.grey900,
  );

  static pw.Widget _buildReportCard(ListLaporanModel report) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      margin: const pw.EdgeInsets.only(bottom: 10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Laporan #${report.noRegistrasi}', style: _titleStyle),
          pw.SizedBox(height: 8),
          pw.Text('Status: ${report.status}', style: _contentStyle),
          pw.Text('Alamat TKP: ${report.alamatTkp}', style: _contentStyle),
          pw.Text(
            'Detail TKP: ${report.alamatDetailTkp}',
            style: _contentStyle,
          ),
          pw.Text(
            'Tanggal Kejadian: ${report.tanggalKejadian.toString().substring(0, 10)}',
            style: _contentStyle,
          ),
          pw.Text(
            'Tanggal Pelaporan: ${report.tanggalPelaporan.toString().substring(0, 10)}',
            style: _contentStyle,
          ),
          pw.Text(
            'Kategori: ${report.violenceCategoryDetail.categoryName}',
            style: _contentStyle,
          ),
          pw.Text(
            'Kronologis: ${report.kronologisKasus}',
            style: _contentStyle,
          ),
          if (report.alasanDibatalkan.isNotEmpty)
            pw.Text(
              'Alasan Dibatalkan: ${report.alasanDibatalkan}',
              style: _contentStyle,
            ),
        ],
      ),
    );
  }

  static Future<File> generateReportsPdf({
    required List<ListLaporanModel> reports,
    required String fileName,
    String title = 'Laporan Kekerasan terhadap anak',
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header:
            (context) => pw.Column(
              children: [
                pw.Text(title, style: _headerStyle),
                pw.Divider(),
                pw.SizedBox(height: 10),
              ],
            ),
        build:
            (context) =>
                reports.map((report) => _buildReportCard(report)).toList(),
      ),
    );

    return await DocumentManagerService.downloadPdf(
      fileName: fileName,
      pdf: pdf,
    );
  }
}

extension PdfDownloadFeatures on AdminProvider {
  // Download semua laporan
}
