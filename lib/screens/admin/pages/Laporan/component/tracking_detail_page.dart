import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/constant/seed.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/create_tracking_dialog.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/delete_tracking_dialog.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/update_tracking_dialog.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/tracking_card.dart';
import 'package:pa2_kelompok07/model/report/tracking_report_model.dart';
import 'package:pa2_kelompok07/provider/report_provider.dart';
import 'package:pa2_kelompok07/styles/color.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

class TrackingPageAdmin extends StatefulWidget {
  final String noRegistrasi;
  final bool isAdmin;
  const TrackingPageAdmin({
    super.key,
    required this.noRegistrasi,
    this.isAdmin = false,
  });

  @override
  State<TrackingPageAdmin> createState() => _TrackingPageAdminState();
}

class _TrackingPageAdminState extends State<TrackingPageAdmin>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(
        context,
        listen: false,
      ).fetchDetailReports(widget.noRegistrasi, isAdmin: widget.isAdmin);
    });
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CreateTrackingDialog(noRegistrasi: widget.noRegistrasi),
    );
  }

  void _showUpdateDialog(TrackingLaporanModel tracking) {
    showDialog(
      context: context,
      builder: (context) => UpdateTrackingDialog(tracking: tracking),
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => DeleteTrackingDialog(id: id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tracking Page",
          style: context.textStyle.onestBold(
            size: SizeScale.lg,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions:
            widget.isAdmin
                ? [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _showCreateDialog,
                  ),
                ]
                : null,
      ),
      body: Consumer<ReportProvider>(
        builder: (context, reportProvider, child) {
          if (reportProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (reportProvider.detailReport != null) {
            final detail = reportProvider.detailReport!.data.trackingLaporan;

            if (detail.isEmpty) {
              return const Center(
                child: PlaceHolderComponent(
                  state: PlaceHolderState.emptyTracking,
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.only(top: responsive.space(SizeScale.md)),
              itemCount: detail.length,
              itemBuilder: (context, index) {
                final isLatest = index == 0;
                return TrackingCardAdmin(
                  tracking: detail[index],
                  isLatest: isLatest,
                  position: detail.length - index,
                  totalSteps: detail.length,
                  isAdmin: widget.isAdmin,
                  onTap: () {},
                  onUpdate: () => _showUpdateDialog(detail[index]),
                  onDelete: () => _showDeleteDialog(detail[index].id),
                );
              },
            );
          } else {
            return const Center(child: Text('Tidak ada data yang tersedia'));
          }
        },
      ),
    );
  }
}
