import 'dart:math' as AppColors;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/screen_navigator.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_hook.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/time_ago.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/custom_icon.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/modals/image_modal.dart';
import 'package:pa2_kelompok07/model/report/list_report_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pa2_kelompok07/screens/admin/pages/Laporan/component/tracking_detail_page.dart';

class ReportDetailModal extends StatefulWidget {
  final ListLaporanModel laporan;
  final VoidCallback onUpdate;
  final Function(BuildContext) onOpenDialog;
  final bool isMe;
  const ReportDetailModal({
    Key? key,
    required this.laporan,
    required this.onUpdate,
    required this.onOpenDialog,
    required this.isMe,
  }) : super(key: key);

  @override
  _ReportDetailModalState createState() => _ReportDetailModalState();
}

class _ReportDetailModalState extends State<ReportDetailModal>
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

  void _openActionDialog() {
    widget.onOpenDialog(context); // Gunakan context dari widget
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;
    final theme = Theme.of(context);
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
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(responsive.borderRadius(SizeScale.md)),
          ),
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
                  width: responsive.widthPercent(20),
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: responsive.space(SizeScale.md)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail Laporan',
                    style: textStyle.onestBold(
                      size: SizeScale.xl,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: responsive.fontSize(SizeScale.lg),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Text(
                widget.laporan.noRegistrasi,
                style: textStyle.onestBold(
                  size: SizeScale.lg,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: responsive.space(SizeScale.lg)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildStatusHeader(context),
                  if (widget.laporan.status == "Laporan masuk" ||
                      widget.laporan.status == "Dilihat")
                    GestureDetector(
                      onTap: _openActionDialog,
                      child: CustomIconButton(
                        icon: Icons.add_circle,
                        color: Color.fromARGB(255, 21, 192, 69),
                      ),
                    ),

                  if (widget.laporan.status == "Diproses")
                    GestureDetector(
                      onTap: _openActionDialog,
                      child: CustomIconButton(
                        icon: Icons.check,
                        color: Color.fromARGB(255, 44, 192, 21),
                      ),
                    ),
                ],
              ),
              SizedBox(height: responsive.space(SizeScale.lg)),

              _buildDetailSection(
                icon: Icons.calendar_today,
                title: 'Tanggal Pelaporan',
                value: _formatDate(widget.laporan.tanggalPelaporan),
              ),
              _buildDetailSection(
                icon: Icons.event,
                title: 'Tanggal Kejadian',
                value: _formatDate(widget.laporan.tanggalKejadian),
              ),
              _buildDetailSection(
                icon: Icons.location_on,
                title: 'Lokasi Kejadian',
                value:
                    '${widget.laporan.alamatTkp}\n${widget.laporan.alamatDetailTkp}',
                isMultiLine: true,
              ),
              _buildDetailSection(
                icon: Icons.category,
                title: 'Kategori Kekerasan',
                value:
                    widget.laporan.violenceCategoryDetail.categoryName ??
                    "Tidak ada Cateogry",
              ),
              _buildDetailSection(
                icon: Icons.place,
                title: 'Kategori Lokasi',
                value: widget.laporan.kategoriLokasiKasus,
              ),
              _buildDetailSection(
                icon: Icons.note,
                title: 'Kronologis',
                value: widget.laporan.kronologisKasus,
                isMultiLine: true,
              ),
              if (widget.laporan.status == "Dibatalkan" &&
                  widget.laporan.alasanDibatalkan != null)
                _buildDetailSection(
                  icon: Icons.cancel,
                  title: 'Alasan Dibatalkan',
                  value: widget.laporan.alasanDibatalkan!,
                  isMultiLine: true,
                ),
              SizedBox(height: responsive.space(SizeScale.lg)),
              _buildDokumentasiSection(context),
              SizedBox(height: responsive.space(SizeScale.lg)),
              if (widget.laporan.useridMelihat != null) ...[
                Text(
                  'Admin yang melihat laporan',
                  style: textStyle.onestBold(
                    size: SizeScale.lg,
                    color: Colors.black,
                  ),
                ),
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
                              "ID Petugas",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                            Text(
                              widget.isMe
                                  ? "Anda petugas yang melihat"
                                  : widget.laporan.useridMelihat.toString(),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (widget.laporan.waktuDilihat != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Waktu Dilihat",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                              Text(
                                _formatDate(
                                  DateTime.parse(widget.laporan!.waktuDilihat!),
                                ),
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
                                        (context) => TrackingPageAdmin(
                                          noRegistrasi:
                                              widget.laporan.noRegistrasi,
                                          isAdmin: true,
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
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Buat Tracking",
                      style: textStyle.onestBold(
                        size: SizeScale.lg,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TrackingPageAdmin(
                                  noRegistrasi: widget.laporan.noRegistrasi,
                                  isAdmin: true,
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
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;
    final status = widget.laporan.status;

    Color backgroundColor;
    Color textColor;
    IconData icon;
    String statusText = status;

    switch (status) {
      case "Laporan masuk":
        backgroundColor = Color.fromARGB(255, 192, 21, 87).withOpacity(0.1);
        textColor = Color.fromARGB(255, 192, 21, 87);
        icon = Icons.refresh_outlined;
        break;
      case "Dilihat":
        backgroundColor = Color(0xFF1565C0).withOpacity(0.1);
        textColor = Color(0xFF1565C0);
        icon = Icons.remove_red_eye;
        statusText +=
            widget.laporan.waktuDilihat != null
                ? ' (${widget.laporan.waktuDilihat})'
                : '';
        break;
      case "Diproses":
        backgroundColor = Color(0xFFB76E00).withOpacity(0.1);
        textColor = Color(0xFFB76E00);
        icon = Icons.autorenew;
        statusText +=
            widget.laporan.waktuDiproses != null
                ? ' (${widget.laporan.waktuDiproses})'
                : '';
        break;
      case "Selesai":
        backgroundColor = Color(0xFF2E7D32).withOpacity(0.1);
        textColor = Color(0xFF2E7D32);
        icon = Icons.check_circle;
        break;
      case "Dibatalkan":
        backgroundColor = Color(0xFFD32F2F).withOpacity(0.1);
        textColor = Color(0xFFD32F2F);
        icon = Icons.cancel;
        statusText +=
            widget.laporan.waktuDibatalkan != null
                ? ' (${widget.laporan.waktuDibatalkan})'
                : '';
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        icon = Icons.help_outline;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.space(SizeScale.md),
        vertical: responsive.space(SizeScale.sm),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          responsive.borderRadius(SizeScale.sm),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: responsive.fontSize(SizeScale.md), color: textColor),
          SizedBox(width: responsive.space(SizeScale.sm)),
          Text(
            statusText.truncate(maxChars: 20),
            style: textStyle.jakartaSansMedium(
              size: SizeScale.md,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required String value,
    bool isMultiLine = false,
  }) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;

    return Padding(
      padding: EdgeInsets.only(bottom: responsive.space(SizeScale.md)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: responsive.fontSize(SizeScale.md),
                color: Colors.grey[600],
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
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: responsive.space(SizeScale.xs)),
                    Text(
                      value,
                      style: textStyle.dmSansRegular(
                        size: SizeScale.md,
                        color: Colors.black,
                      ),
                      maxLines: isMultiLine ? null : 1,
                      overflow: isMultiLine ? null : TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isMultiLine) SizedBox(height: responsive.space(SizeScale.sm)),
          if (!isMultiLine) Divider(height: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }

  Widget _buildDokumentasiSection(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;
    final dokumentasi = widget.laporan.dokumentasi;

    if (dokumentasi.urls.isEmpty) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dokumentasi',
          style: textStyle.onestBold(size: SizeScale.lg, color: Colors.black),
        ),
        SizedBox(height: responsive.space(SizeScale.sm)),
        if (dokumentasi.urls.isNotEmpty) ...[
          Text(
            'Foto',
            style: textStyle.jakartaSansMedium(
              size: SizeScale.md,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: responsive.space(SizeScale.xs)),
          SizedBox(
            height: responsive.heightPercent(15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dokumentasi.urls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: responsive.space(SizeScale.sm),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      ScreenNavigator(cx: context).navigate(
                        FlutterFlowExpandedImageView(
                          image: CachedNetworkImage(
                            imageUrl: dokumentasi.urls[index],

                            fit: BoxFit.contain,
                          ),
                          allowRotation: false,
                          tag: dokumentasi.urls[index],
                          useHeroAnimation: true,
                        ),
                        NavigatorTweens.rightToLeft(),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        responsive.borderRadius(SizeScale.xs),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: dokumentasi.urls[index],
                        width: responsive.widthPercent(30),
                        fit: BoxFit.cover,
                        errorWidget:
                            (context, error, stackTrace) => Container(
                              width: responsive.widthPercent(30),
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey[400],
                              ),
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: responsive.space(SizeScale.md)),
        ],

        // @! KALO NANTI UDA SUPORT VIDIO
        // if (dokumentasi.urls.isNotEmpty) ...[
        //   Text(
        //     'Video',
        //     style: textStyle.jakartaSansMedium(
        //       size: SizeScale.md,
        //       color: Colors.grey[600],
        //     ),
        //   ),
        //   SizedBox(height: responsive.space(SizeScale.xs)),
        //   SizedBox(
        //     height: responsive.heightPercent(15),
        //     child: ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       itemCount: dokumentasi.urls.length,
        //       itemBuilder: (context, index) {
        //         return Padding(
        //           padding: EdgeInsets.only(
        //             right: responsive.space(SizeScale.sm),
        //           ),
        //           child: Stack(
        //             children: [
        //               ClipRRect(
        //                 borderRadius: BorderRadius.circular(
        //                   responsive.borderRadius(SizeScale.xs),
        //                 ),
        //                 child: Container(
        //                   width: responsive.widthPercent(30),
        //                   color: Colors.grey[200],
        //                   child: Center(
        //                     child: Icon(
        //                       Icons.videocam,
        //                       size: responsive.fontSize(SizeScale.xxl),
        //                       color: Colors.grey[400],
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               Positioned.fill(
        //                 child: Material(
        //                   color: Colors.transparent,
        //                   child: InkWell(
        //                     onTap: () => _openVideo(dokumentasi.urls[index]),
        //                     borderRadius: BorderRadius.circular(
        //                       responsive.borderRadius(SizeScale.xs),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               Positioned(
        //                 bottom: responsive.space(SizeScale.xs),
        //                 right: responsive.space(SizeScale.xs),
        //                 child: Container(
        //                   padding: EdgeInsets.all(
        //                     responsive.space(SizeScale.xs),
        //                   ),
        //                   decoration: BoxDecoration(
        //                     color: Colors.black54,
        //                     borderRadius: BorderRadius.circular(4),
        //                   ),
        //                   child: Text(
        //                     'Video ${index + 1}',
        //                     style: textStyle.dmSansRegular(
        //                       size: SizeScale.xs,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        //   SizedBox(height: responsive.space(SizeScale.md)),
        // ],

        // if (dokumentasi.urls.isNotEmpty) ...[
        //   Text(
        //     'Dokumen',
        //     style: textStyle.jakartaSansMedium(
        //       size: SizeScale.md,
        //       color: Colors.grey[600],
        //     ),
        //   ),

        //   SizedBox(height: responsive.space(SizeScale.xs)),
        //   ...dokumentasi.urls
        //       .map(
        //         (doc) => Padding(
        //           padding: EdgeInsets.only(
        //             bottom: responsive.space(SizeScale.sm),
        //           ),
        //           child: ListTile(
        //             leading: Icon(Icons.insert_drive_file, color: Colors.blue),
        //             title: Text(
        //               doc.split('/').last,
        //               style: textStyle.dmSansRegular(size: SizeScale.md),
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //             trailing: Icon(Icons.download, color: Colors.grey),
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(
        //                 responsive.borderRadius(SizeScale.xs),
        //               ),
        //             ),
        //             tileColor:
        //                 Colors
        //                     .grey[50], // Memindahkan tileColor ke luar dari shape
        //             onTap: () => _downloadDocument(doc),
        //           ),
        //         ),
        //       )
        //       .toList(), // Menambahkan toList() untuk mengonversi Iterable menjadi List
        // ],
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _openVideo(String url) {
    // Implement video opening logic
    print('Opening video: $url');
  }

  void _downloadDocument(String url) {
    // Implement document download logic
    print('Downloading document: $url');
  }
}
