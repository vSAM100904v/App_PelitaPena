import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/model/appointment_request_model.dart';

class AppointmentCard extends StatefulWidget {
  final AppointmentRequestModel appointment;
  final VoidCallback onViewPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onCancelPressed;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onViewPressed,
    required this.onEditPressed,
    required this.onCancelPressed,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _borderColorAnimation = ColorTween(
      begin: Colors.grey.withOpacity(0.3),
      end: _getStatusColor(widget.appointment.status).withOpacity(0.5),
    ).animate(_controller);

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

  IconData _getStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.approved:
        return Icons.check_circle;
      case AppointmentStatus.rejected:
        return Icons.cancel;
      case AppointmentStatus.cancelled:
        return Icons.block;
      case AppointmentStatus.pendingApproval:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final appointment = widget.appointment;

    final date = DateFormat(
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

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );
      },
      child: GestureDetector(
        onTap: widget.onViewPressed,
        onTapDown: (_) => _controller.reverse(),
        onTapUp: (_) => _controller.forward(),
        onTapCancel: () => _controller.forward(),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: responsive.space(SizeScale.sm),
            vertical: responsive.space(SizeScale.xs),
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              responsive.borderRadius(SizeScale.sm),
            ),
            border: Border.all(color: _borderColorAnimation.value!, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with status
              Container(
                padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
                decoration: BoxDecoration(
                  color: _getStatusColor(appointment.status).withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      responsive.borderRadius(SizeScale.sm),
                    ),
                    topRight: Radius.circular(
                      responsive.borderRadius(SizeScale.sm),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(appointment.status),
                      size: responsive.space(SizeScale.md),
                      color: _getStatusColor(appointment.status),
                    ),
                    SizedBox(width: responsive.space(SizeScale.sm)),
                    Text(
                      appointment.status.label.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(appointment.status),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time information
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: responsive.space(SizeScale.md),
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: responsive.space(SizeScale.sm)),
                        Text(
                          '$startTime - $endTime WIB',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: responsive.space(SizeScale.sm)),

                    // Location
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: responsive.space(SizeScale.md),
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: responsive.space(SizeScale.sm)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DPMDPPPA Kabupaten Toba',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Jl. Siliwangi No.1, Kec. Balige, Toba, Sumatera Utara',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: responsive.space(SizeScale.md)),

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
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Action buttons
              if (appointment.status == AppointmentStatus.pendingApproval ||
                  appointment.status == AppointmentStatus.approved)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.space(SizeScale.sm),
                    vertical: responsive.space(SizeScale.xs),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: theme.dividerColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // View button
                      _buildActionButton(
                        context,
                        icon: Icons.remove_red_eye,
                        color: Colors.blue,
                        onPressed: widget.onViewPressed,
                      ),

                      if (appointment.status ==
                          AppointmentStatus.pendingApproval) ...[
                        SizedBox(width: responsive.space(SizeScale.sm)),
                        // Edit button
                        _buildActionButton(
                          context,
                          icon: Icons.edit,
                          color: Colors.orange,
                          onPressed: widget.onEditPressed,
                        ),

                        SizedBox(width: responsive.space(SizeScale.sm)),
                        // Cancel button
                        _buildActionButton(
                          context,
                          icon: Icons.delete,
                          color: Colors.red,
                          onPressed: widget.onCancelPressed,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final responsive = context.responsive;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.xs),
          ),
          onTap: onPressed,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              responsive.borderRadius(SizeScale.xs),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: responsive.space(SizeScale.sm),
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(SizeScale.xs),
                ),
              ),
              child: Center(
                // Menambahkan Center untuk memastikan ikon terpusat
                child: Icon(
                  icon,
                  size: responsive.space(SizeScale.md),
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
