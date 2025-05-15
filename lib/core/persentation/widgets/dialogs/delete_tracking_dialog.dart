import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';

import 'package:pa2_kelompok07/provider/report_provider.dart';
import 'package:provider/provider.dart';

class DeleteTrackingDialog extends StatelessWidget {
  final int id;
  const DeleteTrackingDialog({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(responsive.borderRadius(SizeScale.sm)),
        ),
      ),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(responsive.space(SizeScale.md)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon
            Icon(
              Icons.warning_rounded,
              size: responsive.space(SizeScale.xxl),
              color: Colors.orange,
            ),
            SizedBox(height: responsive.space(SizeScale.md)),

            // Title
            Text(
              'Hapus Tracking?',
              style: textStyle.onestBold(size: SizeScale.lg, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.space(SizeScale.sm)),

            // Content
            Text(
              'Apakah Anda yakin ingin menghapus tracking ini?',
              style: textStyle.dmSansRegular(size: SizeScale.md),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.space(SizeScale.lg)),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(SizeScale.xs),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.space(SizeScale.sm),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Batal',
                      style: textStyle.jakartaSansMedium(
                        size: SizeScale.md,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: responsive.space(SizeScale.sm)),

                // Delete Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(SizeScale.xs),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.space(SizeScale.sm),
                      ),
                    ),
                    onPressed: () async {
                      await Provider.of<ReportProvider>(
                        context,
                        listen: false,
                      ).deleteTracking(id.toString());
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Hapus',
                      style: textStyle.jakartaSansMedium(
                        size: SizeScale.md,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
