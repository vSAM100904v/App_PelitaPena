import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/custom_icon.dart';

enum PlaceHolderState {
  noNotifications(
    title: "Belum Ada Notifikasi",
    description:
        "Kami akan memberi tahu Anda ketika ada pembaruan atau informasi terbaru.",
    icon: Icons.notifications_none_outlined,
    iconColor: Colors.grey,
  ),
  noInternet(
    title: "Tidak Ada Koneksi",
    description:
        "Silakan periksa koneksi internet Anda untuk mengakses notifikasi terbaru.",
    icon: Icons.wifi_off_outlined,
    iconColor: Colors.red,
  ),
  error(
    title: "Terjadi Kesalahan",
    description:
        "Kami tidak dapat memuat notifikasi saat ini. Silakan coba lagi nanti.",
    icon: Icons.error_outline,
    iconColor: Colors.orange,
  ),
  customError(
    title: "Kesalahan Kustom",
    description: "Terjadi kesalahan: {errorText}",
    icon: Icons.error_outline,
    iconColor: Colors.orange,
  ),
  emptyTracking(
    title: "Belum Ada Tracking Laporan",
    description:
        "Tracking laporan Anda akan segera dilaporkan begitu ada pembaruan terbaru.",
    icon: Icons.track_changes,
    iconColor: Colors.blue,
  ),

  noScheduledMeetings(
    // State baru untuk tidak ada pertemuan yang terjadwalkan
    title: "Tidak Ada Pertemuan Terjadwalkan",
    description:
        "Saat ini tidak ada pertemuan yang terjadwalkan. Silakan tambahkan pertemuan baru.",
    icon: Icons.calendar_today_outlined,
    iconColor: Colors.grey,
  ),
  noReportedChats(
    title: "Tidak Ada Laporan Chat",
    description:
        "Saat ini tidak ada laporan chat yang tidak pantas dari klien. Kami berkomitmen untuk menampilkan laporan pengaduan terbaru dan bekerja sebaik mungkin untuk menjaga kualitas layanan kami.",
    icon: Icons.report_off_outlined,
    iconColor: Colors.orange,
  ),

  emptyReport(
    title: "Laporan Kosong",
    description:
        "Saat ini tidak ada laporan yang tersedia. Silakan tambahkan laporan baru.",
    icon: Icons.report_off_outlined,
    iconColor: Colors.grey,
  ),
  errorFetchingMessages(
    // Penambahan baru
    title: "Terjadi Kesalahan",
    description:
        "Kami tidak dapat memuat pesan saat ini. Silakan coba lagi nanti.",
    icon: Icons.error_outline,
    iconColor: Colors.orange,
  );

  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  const PlaceHolderState({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}

class PlaceHolderComponent extends StatelessWidget {
  final PlaceHolderState state;
  final String errorCause;
  const PlaceHolderComponent({
    super.key,
    this.state = PlaceHolderState.noNotifications,
    this.errorCause = "",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = context.responsive;
    final color = state.iconColor;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.space(SizeScale.xl)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon with subtle pulse effect
            _buildAnimatedIcon(responsive, color, state.icon),
            SizedBox(height: responsive.space(SizeScale.xxl)),

            // Title with fade animation
            FadeTransition(
              opacity: AlwaysStoppedAnimation(0.9),
              child: Text(
                state.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: responsive.fontSize(SizeScale.xl),
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.9),
                ),
              ),
            ),

            SizedBox(height: responsive.space(SizeScale.sm)),

            // Description text
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.space(SizeScale.xxl),
              ),
              child: Text(
                state.description +
                    (errorCause.isNotEmpty ? " $errorCause" : ""),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: responsive.fontSize(SizeScale.md),
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  height: 1.5,
                ),
              ),
            ),

            SizedBox(height: responsive.space(SizeScale.xxl)),

            // Optional action button
            if (state == PlaceHolderState.noInternet)
              _buildRetryButton(context, responsive),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(
    ResponsiveSizes responsive,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(responsive.space(SizeScale.lg)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: CustomIconButton(
        icon: icon,
        iconSize: responsive.space(SizeScale.xxxl),
        color: color,
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context, ResponsiveSizes responsive) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.symmetric(
          horizontal: responsive.space(SizeScale.xxl),
          vertical: responsive.space(SizeScale.md),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.sm),
          ),
        ),
        elevation: 0,
      ),
      onPressed: () {
        // Add retry logic here
      },
      child: Text(
        "Coba Lagi",
        style: TextStyle(
          fontSize: responsive.fontSize(SizeScale.md),
          color: Colors.white,
        ),
      ),
    );
  }
}
