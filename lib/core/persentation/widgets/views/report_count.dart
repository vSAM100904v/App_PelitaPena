import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';

class LaporanCard extends StatefulWidget {
  final int jumlah;
  final VoidCallback onTap;
  final String reportType;
  const LaporanCard({
    Key? key,
    required this.jumlah,
    required this.onTap,
    required this.reportType,
  }) : super(key: key);

  @override
  State<LaporanCard> createState() => _LaporanCardState();
}

class _LaporanCardState extends State<LaporanCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final spacing = context.responsive;
    final textStyle = context.textStyle;

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.space(SizeScale.md)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              spacing.borderRadius(SizeScale.xs),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.reportType,
                    style: textStyle.jakartaSansMedium(
                      size: SizeScale.sm,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: spacing.space(SizeScale.xs)),
                  Icon(Icons.description_outlined, color: Colors.grey[600]),
                ],
              ),
              SizedBox(height: spacing.space(SizeScale.sm)),
              Text(
                '${widget.jumlah}',
                style: textStyle.onestBold(
                  size: SizeScale.xxxl,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: spacing.space(SizeScale.md)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: spacing.space(SizeScale.xs),
                    ),
                    backgroundColor: Colors.lightBlue[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        spacing.borderRadius(SizeScale.xs),
                      ),
                    ),
                    elevation: 0,
                  ),
                  onPressed: widget.onTap,
                  icon: Icon(
                    Icons.arrow_forward,
                    size: spacing.fontSize(SizeScale.sm),
                  ),
                  label: Text(
                    'Lihat Selengkapnya',
                    style: textStyle.dmSansRegular(
                      size: SizeScale.sm,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
