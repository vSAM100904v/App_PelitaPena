import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart' show AppColors;
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/model/report/list_report_model.dart';

const Color redColor = Color(0xFFFF0060);
const Color grenColor = Color(0xFF00DFA2);

class ActionDialog extends StatefulWidget {
  final ListLaporanModel laporan;
  final Function(String newStatus)?
  onStatusUpdated; // Callback untuk update status
  const ActionDialog({super.key, required this.laporan, this.onStatusUpdated});

  @override
  State<ActionDialog> createState() => _ActionDialogState();
}

class _ActionDialogState extends State<ActionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _selectedAction = '';

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
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

  void _handleAction(String action) {
    setState(() => _selectedAction = action);
    if (widget.onStatusUpdated != null) {
      widget.onStatusUpdated!(action);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final isProcessing =
        widget.laporan.status == "Laporan masuk" ||
        widget.laporan.status == "Dilihat";
    final isInProgress = widget.laporan.status == "Diproses";

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
              padding: EdgeInsets.all(responsive.space(SizeScale.md)),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkSurface,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDialogHeader(responsive, isProcessing),
                  SizedBox(height: responsive.space(SizeScale.sm)),

                  Text(
                    isProcessing
                        ? "Laporan akan diproses dengan no registrasi ${widget.laporan.noRegistrasi}"
                        : isInProgress
                        ? "Pilih tindakan untuk laporan ${widget.laporan.noRegistrasi}"
                        : "Konfirmasi tindakan",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: responsive.space(SizeScale.lg)),

                  // Tombol aksi dinamis
                  _buildActionButtons(responsive, isProcessing, isInProgress),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(ResponsiveSizes responsive, bool isProcessing) {
    final iconColor = isProcessing ? grenColor : redColor;
    final title = isProcessing ? "Proses Laporan?" : "Tindakan Laporan";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(responsive.space(SizeScale.xs)),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isProcessing ? Icons.autorenew : Icons.warning,
            size: responsive.space(SizeScale.lg),
            color: iconColor,
          ),
        ),
        SizedBox(width: responsive.space(SizeScale.sm)),
        Text(title, style: context.textStyle.onestBold(size: SizeScale.md)),
      ],
    );
  }

  Widget _buildActionButtons(
    ResponsiveSizes responsive,
    bool isProcessing,
    bool isInProgress,
  ) {
    if (isProcessing) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: _outlinedButtonStyle(responsive, redColor),
              onPressed: () => Navigator.pop(context),
              child: Text("Batal", style: TextStyle(color: redColor)),
            ),
          ),
          SizedBox(width: responsive.space(SizeScale.sm)),
          Expanded(
            child: ElevatedButton(
              style: _elevatedButtonStyle(responsive, grenColor),
              onPressed: () => _handleAction("Diproses"),
              child: Text("Proses", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    } else if (isInProgress) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: _elevatedButtonStyle(responsive, grenColor),
              onPressed: () => _handleAction("Selesai"),
              child: Text(
                "Tandai Selesai",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: responsive.space(SizeScale.sm)),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: _outlinedButtonStyle(responsive, redColor),
              onPressed: () => Navigator.pop(context),
              child: Text("Tutup", style: TextStyle(color: redColor)),
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  ButtonStyle _elevatedButtonStyle(ResponsiveSizes responsive, Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.symmetric(vertical: responsive.space(SizeScale.md)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    );
  }

  ButtonStyle _outlinedButtonStyle(ResponsiveSizes responsive, Color color) {
    return OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: responsive.space(SizeScale.md)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: color),
    );
  }
}
