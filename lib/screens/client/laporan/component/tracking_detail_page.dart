import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/constant/seed.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/tracking_card.dart';
import 'package:provider/provider.dart';

import '../../../../model/report/full_report_model.dart';
import '../../../../model/report/tracking_report_model.dart';
import '../../../../provider/report_provider.dart';
import '../../../../styles/color.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingPage extends StatefulWidget {
  final String noRegistrasi;

  const TrackingPage({super.key, required this.noRegistrasi});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> with TextLogger {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(
        context,
        listen: false,
      ).fetchDetailReports(widget.noRegistrasi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Laporan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<ReportProvider>(
        builder: (context, reportProvider, child) {
          if (reportProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (reportProvider.errorMessage != null) {
            return Center(child: Text('Error: ${reportProvider.errorMessage}'));
          } else if (reportProvider.detailReport != null) {
            final detail = reportProvider.detailReport!.data.trackingLaporan;
            debugLog(
              "detailReport.toString(): ${reportProvider.detailReport!.data.trackingLaporan}",
            );

            if (detail.isEmpty) {
              return const PlaceHolderComponent(
                state: PlaceHolderState.emptyTracking,
              );
            }
            return ListView.builder(
              padding: EdgeInsets.only(
                top: context.responsive.space(SizeScale.md),
              ),
              itemCount: detail.length,
              itemBuilder: (context, index) {
                final isLatest = index == 0;
                return TrackingCard(
                  tracking: detail[index],
                  isLatest: isLatest,
                  onTap: () {
                    // Handle card tap if needed
                  },
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
