import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocumentManagerService {
  //  final Logger _logger = Logger("Documen Service")
  //  example _logger.log() //is Custom Function i've bean created
  static Future<File> createPdf({
    required String fileName,
    required pw.Document pdf,
  }) async {
    try {
      final directory =
          Platform.isAndroid
              ? await getExternalStorageDirectory()
              : await getApplicationDocumentsDirectory();

      final filePath = '${directory!.path}/$fileName';
      final file = File(filePath);

      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      throw Exception('Gagal membuat PDF: $e');
    }
  }

  /// Membuka file PDF
  static Future<void> openPdf(File file) async {
    try {
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        throw Exception('Gagal membuka PDF: ${result.message}');
      }
    } catch (e) {
      throw Exception('Error saat membuka PDF: $e');
    }
  }

  /// Mengunduh/menyimpan PDF ke direktori download
  static Future<File> downloadPdf({
    required String fileName,
    required pw.Document pdf,
  }) async {
    try {
      // Membuat PDF
      final file = await createPdf(fileName: fileName, pdf: pdf);

      // Mendapatkan direktori download (khusus Android)
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = await getExternalStorageDirectory();
      } else {
        downloadsDir = await getDownloadsDirectory();
      }

      if (downloadsDir != null) {
        final downloadPath = '${downloadsDir.path}/$fileName.pdf';
        return await file.copy(downloadPath);
      }

      return file;
    } catch (e) {
      throw Exception('Gagal mengunduh PDF: $e');
    }
  }

  /// Contoh membuat PDF sederhana dari teks
  static Future<File> convertTextToPdf({
    required String text,
    required String fileName,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Text(text));
          },
        ),
      );

      return await createPdf(fileName: fileName, pdf: pdf);
    } catch (e) {
      throw Exception('Gagal mengkonversi teks ke PDF: $e');
    }
  }

  /// Mendapatkan path file temporary
  static Future<String> getTempFilePath(String fileName) async {
    final tempDir = await getTemporaryDirectory();
    return '${tempDir.path}/$fileName.pdf';
  }

  /// Menghapus file PDF
  static Future<void> deletePdf(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Gagal menghapus PDF: $e');
    }
  }

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
