import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';

class MessageBottomSheet {
  static void show({required BuildContext context, required String message}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _MessageBottomSheetContent(message: message);
      },
    );
  }
}

class _MessageBottomSheetContent extends StatefulWidget {
  final String message;

  const _MessageBottomSheetContent({required this.message});

  @override
  State<_MessageBottomSheetContent> createState() =>
      _MessageBottomSheetContentState();
}

class _MessageBottomSheetContentState
    extends State<_MessageBottomSheetContent> {
  bool _isCopied = false;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;

    return Container(
      margin: EdgeInsets.all(responsive.space(SizeScale.sm)),
      padding: EdgeInsets.all(responsive.space(SizeScale.md)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          responsive.borderRadius(SizeScale.md),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: responsive.widthPercent(15),
            height: 4,
            margin: EdgeInsets.only(bottom: responsive.space(SizeScale.sm)),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Message content
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsive.space(SizeScale.sm),
            ),
            child: Text(
              widget.message,
              style: textStyle.jakartaSansMedium(
                size: SizeScale.md,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: responsive.space(SizeScale.sm)),

          // Copy button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCopied ? Colors.green : Colors.blue,
                padding: EdgeInsets.symmetric(
                  vertical: responsive.space(SizeScale.sm),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    responsive.borderRadius(SizeScale.sm),
                  ),
                ),
              ),
              onPressed: () async {
                if (!_isCopied) {
                  await Clipboard.setData(ClipboardData(text: widget.message));
                  setState(() => _isCopied = true);
                  await Future.delayed(const Duration(seconds: 1));
                  if (mounted) Navigator.pop(context);
                }
              },
              child: Text(
                _isCopied ? 'Copied!' : 'Copy to Clipboard',
                style: textStyle.onestBold(
                  size: SizeScale.md,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
