import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';

class CustomMessenger {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isSuccess = true,
  }) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
          decoration: BoxDecoration(
            color: isSuccess ? Colors.green[500] : Colors.red[500],
            borderRadius: BorderRadius.circular(
              responsive.borderRadius(SizeScale.sm),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: responsive.fontSize(SizeScale.lg),
              ),
              SizedBox(width: responsive.space(SizeScale.sm)),
              Expanded(
                child: Text(
                  message,
                  style: textStyle.dmSansRegular(
                    size: SizeScale.md,
                    color: Colors.white,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: responsive.fontSize(SizeScale.md),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
