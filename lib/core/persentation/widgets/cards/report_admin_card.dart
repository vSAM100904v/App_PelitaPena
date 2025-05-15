import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/time_ago.dart';

class ReportCardAdminView extends StatelessWidget {
  final String title;
  final DateTime reportDate;
  final String status;
  final VoidCallback? onTap;
  final bool isSelected;
  final String? message;
  final VoidCallback? onSelectionChanged;

  const ReportCardAdminView({
    Key? key,
    required this.title,
    required this.reportDate,
    required this.status,
    this.onTap,
    this.message,
    required this.isSelected,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        context.responsive.borderRadius(SizeScale.xs),
      ),
      child: Container(
        padding: EdgeInsets.all(context.responsive.space(SizeScale.md)),
        margin: EdgeInsets.only(bottom: context.responsive.space(SizeScale.sm)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            context.responsive.borderRadius(SizeScale.xs),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (onSelectionChanged != null)
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  onSelectionChanged?.call();
                },
                activeColor: theme.primaryColor,
              ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: context.responsive.fontSize(SizeScale.md),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // SizedBox(width: context.responsive.space(SizeScale.sm)),
            // onSelectionChanged != null
            //     ? Text(
            //       TimeAgo.format(reportDate),
            //       style: TextStyle(
            //         fontSize: context.responsive.fontSize(SizeScale.sm),
            //         color: Colors.grey[600],
            //       ),
            //     )
            //     : message != null
            //     ? Expanded(
            //       child: Text(
            //         message!,
            //         style: TextStyle(
            //           fontSize: context.responsive.fontSize(SizeScale.md),
            //           fontWeight: FontWeight.w500,
            //         ),
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     )
            //     : Text(
            //       TimeAgo.format(reportDate),
            //       style: TextStyle(
            //         fontSize: context.responsive.fontSize(SizeScale.sm),
            //         color: Colors.grey[600],
            //       ),
            //     ),
            SizedBox(width: context.responsive.space(SizeScale.sm)),
            _buildStatusCell(context, status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCell(BuildContext context, String status) {
    final responsive = context.responsive;
    Color textColor;

    switch (status) {
      case "Laporan masuk":
        textColor = Color.fromARGB(255, 192, 21, 87);
        break;
      case "reported":
        textColor = Color.fromARGB(255, 192, 21, 87);
        break;
      case "Dilihat":
        textColor = Color(0xFF1565C0);
        break;
      case "Diproses":
        textColor = Color(0xFFB76E00);
        break;
      case "Selesai":
        textColor = Color(0xFF2E7D32);
        break;
      default:
        textColor = Colors.grey[700]!;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.space(SizeScale.xs),
        vertical: responsive.space(SizeScale.xs) / 2,
      ),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }
}
