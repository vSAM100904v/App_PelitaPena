import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../styles/color.dart';

class AppointmentProcedure extends StatelessWidget {
  const AppointmentProcedure({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tentang Janji Temu",
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderImage(theme),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.location_on_outlined,
                    title: "Lokasi",
                    subtitle: "DPMDPPPA Kabupaten Toba",
                    description:
                        "Jl. Siliwangi No.1, Kec. Balige, Toba, Sumatera Utara",
                    actionText: "Lihat di Map",
                    onAction: _launchMap,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.access_time_outlined,
                    title: "Jam Operasional",
                    subtitle: "Senin - Jumat",
                    description: "08:00 - 17:00 WIB",
                  ),
                  const SizedBox(height: 24),
                  _buildAboutSection(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(ThemeData theme) {
    return Stack(
      children: [
        ClipRRect(
          child: Image.asset(
            'assets/bg_appointment.png',
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
          child: Center(
            child: Text(
              'Layanan Janji Temu',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(blurRadius: 10, color: Colors.black.withOpacity(0.5)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 24, color: AppColor.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: onAction,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColor.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    actionText,
                    style: TextStyle(color: AppColor.primaryColor),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentang Layanan',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Waktunya untuk bertindak dan membuat perubahan! Gunakan fitur request janji temu kami sekarang juga untuk mendapatkan bantuan yang Anda butuhkan dalam kasus kekerasan yang Anda alami.\n\n'
              'Jangan biarkan kesulitan menghalangi keadilan. Isi formulir dengan cerdas, tentukan waktu yang tepat, dan saksikan bagaimana kami memproses permintaan Anda dengan cepat dan efisien.\n\n'
              'Ayo, jangan tunda lagi, inisiatif Anda dapat membuat perbedaan besar. Aplikasi ini adalah alat Anda untuk memperjuangkan keadilan. Ajukan pertemuan Anda sekarang dan mari bersama-sama melawan kekerasan!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchMap() async {
    const url =
        'https://www.google.com/maps/search/?api=1&query=DPMDPPPA+Kabupaten+Toba';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
