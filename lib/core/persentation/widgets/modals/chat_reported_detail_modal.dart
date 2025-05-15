import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/models/reported_chat_model.dart';
import 'package:pa2_kelompok07/styles/color.dart';

class ReportedChatDetailModal extends StatefulWidget {
  final ReportedChat chatReport;
  final Function(BuildContext) onOpenDialog;
  final bool isMe;

  const ReportedChatDetailModal({
    Key? key,
    required this.chatReport,
    required this.onOpenDialog,
    required this.isMe,
  }) : super(key: key);

  @override
  _ReportedChatDetailModalState createState() =>
      _ReportedChatDetailModalState();
}

class _ReportedChatDetailModalState extends State<ReportedChatDetailModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveSizes(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          top: responsive.space(SizeScale.md),
          left: responsive.space(SizeScale.md),
          right: responsive.space(SizeScale.md),
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
              responsive.space(SizeScale.md),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: responsive.screenWidth * 0.2,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: responsive.space(SizeScale.md)),
              Text(
                'Report Details',
                style: TextStyle(
                  fontSize: responsive.fontSize(SizeScale.lg),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: responsive.space(SizeScale.sm)),
              _buildDetailRow(
                context,
                responsive,
                'Report ID',
                widget.chatReport.reportId,
              ),
              _buildDetailRow(
                context,
                responsive,
                'Reporter',
                widget.chatReport.reporterUsername,
              ),
              _buildDetailRow(
                context,
                responsive,
                'Reported User',
                widget.chatReport.reportedUserUsername,
              ),
              _buildDetailRow(
                context,
                responsive,
                'Message Content',
                widget.chatReport.messageContent,
              ),
              _buildDetailRow(
                context,
                responsive,
                'Report Type',
                widget.chatReport.reportType,
              ),
              _buildDetailRow(
                context,
                responsive,
                'Status',
                widget.chatReport.status,
              ),
              _buildDetailRow(
                context,
                responsive,
                'Date Reported',
                widget.chatReport.tanggalPelaporan.toString().substring(0, 10),
              ),
              _buildDetailRow(
                context,
                responsive,
                'Notes',
                widget.chatReport.notes ?? 'No notes',
              ),
              SizedBox(height: responsive.space(SizeScale.md)),
              if (widget.isMe)
                Center(
                  child: ElevatedButton(
                    onPressed: () => widget.onOpenDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.space(SizeScale.xl),
                        vertical: responsive.space(SizeScale.sm),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Open Action Dialog',
                      style: TextStyle(
                        fontSize: responsive.fontSize(SizeScale.sm),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: responsive.space(SizeScale.md)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    ResponsiveSizes responsive,
    String label,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.space(SizeScale.xs)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: responsive.screenWidth * 0.3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: responsive.fontSize(SizeScale.sm),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: responsive.fontSize(SizeScale.sm),
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
