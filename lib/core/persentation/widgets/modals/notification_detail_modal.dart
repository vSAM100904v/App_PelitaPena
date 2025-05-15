import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/models/notification_channel_model.dart';
import 'package:pa2_kelompok07/core/models/notification_response_model.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/custom_icon.dart';
import 'package:pa2_kelompok07/core/utils/notification_type_util.dart';

class NotificationDetail extends StatefulWidget {
  final NotificationPayload notification;
  final VoidCallback? onPressed;
  const NotificationDetail({
    super.key,
    required this.notification,
    this.onPressed,
  });

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail>
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

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isImportant = false,
  }) {
    final theme = Theme.of(context);
    final responsive = context.responsive;
    print(widget.notification);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.space(SizeScale.xs)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: responsive.widthPercent(30),
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: responsive.fontSize(SizeScale.sm),
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          SizedBox(width: responsive.space(SizeScale.sm)),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: responsive.fontSize(
                  isImportant ? SizeScale.md : SizeScale.sm,
                ),
                fontWeight: isImportant ? FontWeight.w600 : FontWeight.normal,
                color: theme.colorScheme.onSurface.withOpacity(
                  isImportant ? 0.9 : 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = context.responsive;
    final notification = widget.notification;
    final fcmData = notification.data;

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
              constraints: BoxConstraints(
                maxHeight: responsive.heightPercent(80),
              ),
              padding: EdgeInsets.all(responsive.space(SizeScale.xxl)),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkSurface,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with icon and sender
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            responsive.space(SizeScale.xs),
                          ),
                          decoration: BoxDecoration(
                            color: NotificationTypeUtils.getColor(
                              notification.type,
                            ).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconButton(
                            icon: NotificationTypeUtils.getIcon(
                              notification.type,
                            ),
                            iconSize: responsive.space(SizeScale.xxl),
                            color: NotificationTypeUtils.getColor(
                              notification.type,
                            ),
                          ),
                        ),
                        SizedBox(width: responsive.space(SizeScale.md)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: responsive.fontSize(SizeScale.lg),
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                _formatDateTime(
                                  notification.createdAt.toIso8601String(),
                                ),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: responsive.space(SizeScale.lg)),

                    // Notification body
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant.withOpacity(
                          0.3,
                        ),
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(SizeScale.sm),
                        ),
                      ),
                      child: Text(
                        notification.body,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),

                    SizedBox(height: responsive.space(SizeScale.lg)),

                    // Status information
                    if (fcmData.status != null)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            fcmData.status!,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(SizeScale.sm),
                          ),
                          border: Border.all(
                            color: _getStatusColor(
                              fcmData.status!,
                            ).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getStatusIcon(fcmData.status!),
                              size: responsive.space(SizeScale.xl),
                              color: _getStatusColor(fcmData.status!),
                            ),
                            SizedBox(width: responsive.space(SizeScale.md)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    NotificationTypeUtils.getSender(
                                      notification.type,
                                    ),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  Text(
                                    _getStatusLabel(fcmData.status),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: _getStatusColor(fcmData.status!),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: responsive.space(SizeScale.lg)),

                    // Detailed information
                    Text(
                      'Detail Informasi',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: responsive.space(SizeScale.sm)),

                    Divider(
                      height: 1,
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                    ),
                    SizedBox(height: responsive.space(SizeScale.sm)),

                    _buildDetailRow(
                      'Nomor Laporan',
                      fcmData.reportId ?? '-',
                      isImportant: true,
                    ),
                    _buildDetailRow(
                      'Diperbarui Oleh',
                      'Petugas ID: ${fcmData.updatedBy ?? '-'}',
                    ),
                    _buildDetailRow(
                      'Waktu Pembaruan',
                      _formatDateTime(fcmData.updatedAt),
                    ),

                    if (fcmData.notes != null && fcmData.notes!.isNotEmpty)
                      _buildDetailRow('Catatan', fcmData.notes!),

                    SizedBox(height: responsive.space(SizeScale.lg)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: responsive.space(SizeScale.md),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: NotificationTypeUtils.getColor(
                                  notification.type,
                                ),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              "Tutup",
                              style: TextStyle(
                                color: NotificationTypeUtils.getColor(
                                  notification.type,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: responsive.space(SizeScale.md)),
                        if (widget.notification.type !=
                            NotificationType.admin_notification)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: NotificationTypeUtils.getColor(
                                  notification.type,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: responsive.space(SizeScale.md),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed:
                                  () =>
                                      widget.onPressed != null
                                          ? widget.onPressed?.call()
                                          : Navigator.pop(context, true),
                              child: Text(
                                "Lihat Laporan",
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.blue;
      case 'new_tracking':
        return Colors.greenAccent;
      case 'updated_tracking':
        return Colors.grey.shade800;
      case 'deleted_tracking':
        return Colors.red.shade800;
      default:
        return Colors.grey; // Warna default
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'in_progress':
        return Icons.autorenew;
      case 'completed':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.access_time;
      case 'new_tracking':
        return Icons.new_releases;
      case 'updated_tracking':
        return Icons.update;
      case 'deleted_tracking':
        return Icons.delete;
      case "chat_message":
        return Icons.chat_bubble;
      default:
        return Icons.chat_bubble;
    }
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return '-';
    final dateTime = DateTime.tryParse(dateTimeString);
    if (dateTime == null) return '-';

    return DateFormat(
      'dd MMMM yyyy, HH:mm',
      'id_ID',
    ).format(dateTime.toLocal());
  }

  String _getStatusLabel(String? status) {
    switch (status) {
      case 'in_progress':
        return 'Dalam Proses';
      case 'completed':
        return 'Selesai';
      case 'rejected':
        return 'Ditolak';
      case 'pending':
        return 'Menunggu';
      case 'new_tracking':
        return "Traking Baru";
      case 'updated_tracking':
        return "Tracking di perbarui";
      case 'deleted_tracking':
        return "Tracking di hapus";
      case 'chat_message':
        return "Pesan Baru";
      default:
        return status ?? 'Pesan Baru';
    }
  }
}
