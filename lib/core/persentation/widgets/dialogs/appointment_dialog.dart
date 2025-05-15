import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/model/appointment_request_model.dart';

class AppointmentDetailsDialog extends StatefulWidget {
  final AppointmentRequestModel appointment;

  const AppointmentDetailsDialog({super.key, required this.appointment});

  @override
  State<AppointmentDetailsDialog> createState() =>
      _AppointmentDetailsDialogState();
}

class _AppointmentDetailsDialogState extends State<AppointmentDetailsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.approved:
        return Colors.green;
      case AppointmentStatus.rejected:
        return Colors.red;
      case AppointmentStatus.cancelled:
        return Colors.grey;
      case AppointmentStatus.pendingApproval:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final appointment = widget.appointment;

    final formattedDate = DateFormat(
      'EEEE, d MMMM yyyy',
      'id_ID',
    ).format(DateTime.parse(appointment.waktuDimulai));
    final startTime = DateFormat(
      'HH:mm',
      'id_ID',
    ).format(DateTime.parse(appointment.waktuDimulai));
    final endTime = DateFormat(
      'HH:mm',
      'id_ID',
    ).format(DateTime.parse(appointment.waktuSelesai));

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: EdgeInsets.all(responsive.space(SizeScale.lg)),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(SizeScale.md),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.space(SizeScale.sm),
                          vertical: responsive.space(SizeScale.xs),
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            appointment.status,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          appointment.status.label.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _getStatusColor(appointment.status),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: responsive.space(SizeScale.md),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),

                  SizedBox(height: responsive.space(SizeScale.md)),

                  // Title
                  Text(
                    'Detail Janji Temu',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: responsive.space(SizeScale.lg)),

                  // Consultation purpose
                  Text(
                    'Keperluan Konsultasi:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: responsive.space(SizeScale.xs)),
                  Text(
                    appointment.keperluanKonsultasi,
                    style: theme.textTheme.bodyLarge,
                  ),

                  SizedBox(height: responsive.space(SizeScale.lg)),

                  // Date and time
                  _buildDetailRow(
                    context,
                    icon: Icons.calendar_today,
                    label: 'Tanggal',
                    value: formattedDate,
                  ),

                  _buildDetailRow(
                    context,
                    icon: Icons.access_time,
                    label: 'Waktu',
                    value: '$startTime - $endTime WIB',
                  ),

                  _buildDetailRow(
                    context,
                    icon: Icons.location_on,
                    label: 'Lokasi',
                    value:
                        'DPMDPPPA Kabupaten Toba\nJl. Siliwangi No.1, Kec. Balige, Toba, Sumatera Utara',
                  ),

                  // Additional info for rejected/cancelled appointments
                  if (appointment.status == AppointmentStatus.rejected &&
                      appointment.alasanDitolak != null)
                    _buildReasonSection(
                      context,
                      title: 'Alasan Penolakan',
                      content: appointment.alasanDitolak!,
                    ),

                  if (appointment.status == AppointmentStatus.cancelled &&
                      appointment.alasanDibatalkan != null)
                    _buildReasonSection(
                      context,
                      title: 'Alasan Pembatalan',
                      content: appointment.alasanDibatalkan!,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: responsive.space(SizeScale.md)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: responsive.space(SizeScale.md),
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: responsive.space(SizeScale.sm)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: responsive.space(SizeScale.xs)),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: responsive.space(SizeScale.lg)),
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.error,
          ),
        ),
        SizedBox(height: responsive.space(SizeScale.xs)),
        Container(
          padding: EdgeInsets.all(responsive.space(SizeScale.md)),
          decoration: BoxDecoration(
            color: theme.colorScheme.error.withOpacity(0.05),
            borderRadius: BorderRadius.circular(
              responsive.borderRadius(SizeScale.xs),
            ),
            border: Border.all(color: theme.colorScheme.error.withOpacity(0.2)),
          ),
          child: Text(content, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

// Updated showAppointmentDetailsDialog function
void showAppointmentDetailsDialog(
  BuildContext context,
  AppointmentRequestModel appointment,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AppointmentDetailsDialog(appointment: appointment);
    },
  );
}
