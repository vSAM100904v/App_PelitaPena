import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:provider/provider.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final String userName;
  final Function() onLogoutConfirmed;

  const LogoutConfirmationDialog({
    super.key,
    required this.userName,
    required this.onLogoutConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          responsive.borderRadius(SizeScale.md),
        ),
      ),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(responsive.space(SizeScale.md)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Icon
            Icon(
              Icons.account_circle_rounded,
              size: responsive.space(SizeScale.xxl),
              color: colorScheme.primary,
            ),
            SizedBox(height: responsive.space(SizeScale.md)),

            // Personalized Message
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: textStyle.dmSansRegular(size: SizeScale.md),
                children: [
                  TextSpan(
                    text: 'Hebat $userName, ',
                    style: textStyle.onestBold(
                      size: SizeScale.md,
                      color: colorScheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: 'Anda telah bekerja dengan sangat baik hari ini!',
                    style: textStyle.dmSansRegular(
                      size: SizeScale.md,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.space(SizeScale.md)),

            // Confirmation Text

            // Buttons Row
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.primary),
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
                      'Tidak',
                      style: textStyle.jakartaSansMedium(
                        size: SizeScale.sm,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: responsive.space(SizeScale.sm)),

                // Logout Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(SizeScale.xs),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.space(SizeScale.sm),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      onLogoutConfirmed(); // Execute logout
                    },
                    child: Text(
                      'Ya, Logout',
                      style: textStyle.jakartaSansMedium(
                        size: SizeScale.sm,
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
