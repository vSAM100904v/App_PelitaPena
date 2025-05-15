import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/core/services/pdf_service.dart';
import 'package:pa2_kelompok07/provider/admin_provider.dart';
import 'package:provider/provider.dart';

class DonwloadedPdfDialog extends StatefulWidget {
  final AdminProvider adminProvider;

  const DonwloadedPdfDialog({Key? key, required this.adminProvider})
    : super(key: key);

  @override
  _DonwloadedPdfDialogState createState() => _DonwloadedPdfDialogState();
}

class _DonwloadedPdfDialogState extends State<DonwloadedPdfDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;
  String _currentAction = '';

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

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDownload(
    Future<File> Function() downloadFunction,
    String actionName,
  ) async {
    setState(() {
      _isLoading = true;
      _currentAction = actionName;
    });

    try {
      final file = await downloadFunction();
      await DocumentManagerService.openPdf(file);
      if (!mounted) return;
      context.toast.showSuccess("PDF berhasil diunduh");
    } catch (e) {
      if (!mounted) return;
      context.toast.showError("Error $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentAction = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyle;
    final responsive = context.responsive;
    final theme = Theme.of(context);
    print(
      "PANJANG DARI SELECTED REPORT ${widget.adminProvider.selectedReports.length}",
    );
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              width: responsive.widthPercent(85),
              padding: EdgeInsets.all(responsive.space(SizeScale.md)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(SizeScale.lg),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Download Laporan',
                        style: textStyle.onestBold(
                          size: SizeScale.lg,
                          color: theme.primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: responsive.fontSize(SizeScale.md),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.space(SizeScale.md)),

                  // Download All Reports
                  _buildDownloadOption(
                    context: context,
                    icon: Icons.download_rounded,
                    title: 'Download Semua Laporan',
                    description: 'Unduh seluruh laporan dalam satu file PDF',
                    isLoading:
                        _isLoading &&
                        _currentAction == 'download semua laporan',
                    onTap:
                        () => _handleDownload(
                          () => widget.adminProvider.downloadAllReports(),
                          'download semua laporan',
                        ),
                  ),
                  // Download Selected Reports
                  if (widget.adminProvider.selectedReports.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: responsive.space(SizeScale.md)),
                        Divider(height: 1, color: Colors.grey[200]),
                        SizedBox(height: responsive.space(SizeScale.md)),
                        _buildDownloadOption(
                          context: context,
                          icon: Icons.check_circle,
                          title: 'Download Laporan Terpilih',
                          description:
                              'Unduh laporan yang telah dipilih (${widget.adminProvider.selectedReports.length})',
                          isLoading:
                              _isLoading &&
                              _currentAction == 'download laporan terpilih',
                          onTap:
                              () => _handleDownload(
                                () =>
                                    widget.adminProvider
                                        .downloadSelectedReports(),
                                'download laporan terpilih',
                              ),
                        ),
                      ],
                    ),

                  SizedBox(height: responsive.space(SizeScale.md)),
                  Divider(height: 1, color: Colors.grey[200]),
                  SizedBox(height: responsive.space(SizeScale.md)),

                  // Download Current Page
                  _buildDownloadOption(
                    context: context,
                    icon: Icons.file_download,
                    title: 'Download Halaman Saat Ini',
                    description:
                        'Unduh laporan hanya pada halaman yang sedang ditampilkan',
                    isLoading:
                        _isLoading &&
                        _currentAction == 'download halaman saat ini',
                    onTap:
                        () => _handleDownload(
                          () => widget.adminProvider.downloadPageReports(
                            widget.adminProvider.currentPage,
                          ),
                          'download halaman saat ini',
                        ),
                  ),

                  SizedBox(height: responsive.space(SizeScale.md)),
                  Divider(height: 1, color: Colors.grey[200]),
                  SizedBox(height: responsive.space(SizeScale.md)),

                  // Download Single Report
                  // ... kode sebelumnya ...

                  // ... kode setelahnya ...
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    final textStyle = context.textStyle;
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(
        responsive.borderRadius(SizeScale.sm),
      ),
      child: Container(
        padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.sm),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: responsive.space(SizeScale.xxl),
              height: responsive.space(SizeScale.xxl),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(SizeScale.sm),
                ),
              ),
              child: Icon(
                icon,
                size: responsive.fontSize(SizeScale.md),
                color: theme.primaryColor,
              ),
            ),
            SizedBox(width: responsive.space(SizeScale.sm)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textStyle.jakartaSansMedium(
                      size: SizeScale.sm,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: responsive.space(SizeScale.xs)),
                  Text(
                    description,
                    style: textStyle.dmSansRegular(
                      size: SizeScale.xs,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: responsive.space(SizeScale.sm)),
            if (isLoading)
              SizedBox(
                width: responsive.space(SizeScale.md),
                height: responsive.space(SizeScale.md),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                size: responsive.fontSize(SizeScale.md),
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }
}
