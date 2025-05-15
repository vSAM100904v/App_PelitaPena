import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/custom_icon.dart';
import 'package:pa2_kelompok07/provider/report_provider.dart';
import 'package:pa2_kelompok07/screens/client/dpmdppa/report_cancel_screen.dart';
import 'package:pa2_kelompok07/screens/client/laporan/component/tracking_detail_page.dart';
import 'package:pa2_kelompok07/styles/color.dart';
import 'package:provider/provider.dart';

class DetailReportScreen extends StatefulWidget {
  final String noRegistrasi;

  const DetailReportScreen({super.key, required this.noRegistrasi});

  @override
  State<DetailReportScreen> createState() => _DetailReportScreenState();
}

class _DetailReportScreenState extends State<DetailReportScreen>
    with TextLogger {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(
        context,
        listen: false,
      ).fetchDetailReports(widget.noRegistrasi);
    });
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(date);
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'laporan masuk':
        return 'Laporan Masuk';
      case 'diproses':
        return 'Sedang Diproses';
      case 'dibatalkan':
        return 'Dibatalkan';
      case 'selesai':
        return 'Selesai';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'laporan masuk':
        return Colors.blue;
      case 'diproses':
        return Colors.orange;
      case 'dibatalkan':
        return Colors.red;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildDetailCard({
    required BuildContext context,
    required String title,
    required String value,
    IconData? icon,
  }) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: responsive.space(SizeScale.sm)),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          responsive.borderRadius(SizeScale.xs),
        ),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.space(SizeScale.md)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(right: responsive.space(SizeScale.sm)),
                child: Icon(
                  icon,
                  size: responsive.space(SizeScale.lg),
                  color: theme.primaryColor,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: responsive.fontSize(SizeScale.sm),
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: responsive.space(SizeScale.xs)),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: responsive.fontSize(SizeScale.md),
                      color: theme.colorScheme.onSurface.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        _getStatusLabel(status),
        style: TextStyle(
          color: _getStatusColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Laporan",
          style: TextStyle(
            fontSize: responsive.fontSize(SizeScale.lg),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<ReportProvider>(
        builder: (context, reportProvider, child) {
          if (reportProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primaryColor),
            );
          }

          if (reportProvider.detailReport?.code != 200) {
            return Center(
              child: PlaceHolderComponent(
                state: PlaceHolderState.customError,
                errorCause: 'Error: ${reportProvider.errorMessage}',
              ),
            );
          }

          if (reportProvider.detailReport == null) {
            return Center(
              child: PlaceHolderComponent(
                state: PlaceHolderState.noNotifications,
              ),
            );
          }

          final detail = reportProvider.detailReport!.data;
          final formattedDate = _formatDateTime(detail.createdAt);

          return SingleChildScrollView(
            padding: EdgeInsets.all(responsive.space(SizeScale.md)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan nomor registrasi dan status
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(SizeScale.sm),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "No. Registrasi",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                            Text(
                              detail.noRegistrasi,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: responsive.space(SizeScale.sm)),
                        Divider(
                          height: 1,
                          color: theme.dividerColor.withOpacity(0.2),
                        ),
                        SizedBox(height: responsive.space(SizeScale.sm)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tracking Laporan",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TrackingPage(
                                          noRegistrasi: detail.noRegistrasi,
                                        ),
                                  ),
                                );
                              },
                              child: CustomIconButton(
                                icon: Icons.chevron_right,
                                color: Colors.black,
                                iconSize: responsive.space(SizeScale.lg),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: responsive.space(SizeScale.sm)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status Laporan",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                            _buildStatusBadge(detail.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: responsive.space(SizeScale.lg)),

                // Gambar kategori kekerasan
                if (detail.violenceCategory.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(SizeScale.sm),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: detail.violenceCategory.image!,
                      width: double.infinity,
                      height: responsive.heightPercent(25),
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(color: Colors.grey[200]),
                      errorWidget:
                          (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: CustomIconButton(
                              icon: Icons.broken_image,
                              iconSize: responsive.space(SizeScale.xxl),
                              color: AppColor.descColor,
                            ),
                          ),
                    ),
                  ),

                SizedBox(height: responsive.space(SizeScale.lg)),

                // Informasi dasar laporan
                Text(
                  "Informasi Laporan",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: responsive.space(SizeScale.sm)),

                _buildDetailCard(
                  context: context,
                  title: "Tanggal Pelaporan",
                  value: formattedDate,
                  icon: Icons.calendar_today,
                ),

                _buildDetailCard(
                  context: context,
                  title: "Tanggal Kejadian",
                  value: _formatDateTime(detail.tanggalKejadian),
                  icon: Icons.event,
                ),

                _buildDetailCard(
                  context: context,
                  title: "Kategori Kekerasan",
                  value:
                      detail.violenceCategory.categoryName ?? "unkonw category",
                  icon: Icons.category,
                ),

                _buildDetailCard(
                  context: context,
                  title: "Lokasi Kejadian",
                  value: detail.kategoriLokasiKasus,
                  icon: Icons.location_on,
                ),

                _buildDetailCard(
                  context: context,
                  title: "Alamat TKP",
                  value: detail.alamatTkp,
                  icon: Icons.place,
                ),

                if (detail.alamatDetailTkp.isNotEmpty)
                  _buildDetailCard(
                    context: context,
                    title: "Detail Alamat TKP",
                    value: detail.alamatDetailTkp,
                    icon: Icons.description,
                  ),

                SizedBox(height: responsive.space(SizeScale.lg)),

                // Informasi pelapor
                Text(
                  "Informasi Pelapor",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: responsive.space(SizeScale.sm)),

                _buildDetailCard(
                  context: context,
                  title: "Nama Lengkap",
                  value: detail.user.full_name,
                  icon: Icons.person,
                ),

                SizedBox(height: responsive.space(SizeScale.lg)),

                // Kronologis kasus
                Text(
                  "Kronologis Kasus",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: responsive.space(SizeScale.sm)),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(SizeScale.xs),
                    ),
                    side: BorderSide(
                      color: theme.dividerColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                    child: Text(
                      detail.kronologisKasus.isNotEmpty
                          ? detail.kronologisKasus
                          : "Tidak ada kronologis yang diberikan",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),

                SizedBox(height: responsive.space(SizeScale.lg)),

                // Tombol aksi
                if (detail.status.toLowerCase() == 'laporan masuk')
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ReportCancelScreen(
                                noRegistrasi: widget.noRegistrasi,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                      minimumSize: Size(
                        double.infinity,
                        responsive.space(SizeScale.xxxl),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(SizeScale.sm),
                        ),
                        side: BorderSide(color: Colors.red.withOpacity(0.3)),
                      ),
                    ),
                    child: Text(
                      'Batalkan Laporan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                SizedBox(height: responsive.space(SizeScale.lg)),
              ],
            ),
          );
        },
      ),
    );
  }
}
