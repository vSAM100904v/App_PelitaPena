import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/time_ago.dart';
import 'package:pa2_kelompok07/model/report/list_report_model.dart';

class ReportCard extends StatefulWidget {
  final ListLaporanModel report;
  final VoidCallback onTap;

  const ReportCard({super.key, required this.report, required this.onTap});

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _shadowColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _shadowColorAnimation = ColorTween(
      begin: Colors.grey.withOpacity(0.1),
      end: Colors.grey.withOpacity(0.3),
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diproses':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final report = widget.report;
    final timeAgo = TimeAgo.format(report.createdAt);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          _controller.reverse().then((_) {
            widget.onTap();
            _controller.forward();
          });
        },
        onTapDown: (_) => _controller.reverse(),
        onTapCancel: () => _controller.forward(),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: responsive.space(SizeScale.sm),
            vertical: responsive.space(SizeScale.xs),
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              responsive.borderRadius(SizeScale.sm),
            ),
            boxShadow: [
              BoxShadow(
                color: _shadowColorAnimation.value!,
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              responsive.borderRadius(SizeScale.sm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image and category section
                Stack(
                  children: [
                    // Image with shimmer effect
                    (report?.dokumentasi?.urls != null &&
                            report!.dokumentasi!.urls.isNotEmpty &&
                            report.dokumentasi!.urls.first.isNotEmpty)
                        ? CachedNetworkImage(
                          imageUrl: report.dokumentasi!.urls.first,
                          width: double.infinity,
                          height: responsive.heightPercent(15),
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                                  Container(color: Colors.grey[200]),
                          errorWidget:
                              (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.broken_image,
                                  size: responsive.space(SizeScale.xxl),
                                  color: Colors.grey[400],
                                ),
                              ),
                        )
                        : Container(
                          width: double.infinity,
                          height: responsive.heightPercent(15),
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.broken_image,
                            size: responsive.space(SizeScale.xxl),
                            color: Colors.grey[400],
                          ),
                        ),

                    // Status badge
                    Positioned(
                      top: responsive.space(SizeScale.sm),
                      right: responsive.space(SizeScale.sm),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.space(SizeScale.sm),
                          vertical: responsive.space(SizeScale.xs),
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            report.status,
                          ).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          report.status.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.fontSize(SizeScale.xs),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Content section
                Padding(
                  padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category and time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              report.violenceCategoryDetail.categoryName ?? '',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontSize: responsive.fontSize(SizeScale.md),
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: responsive.space(SizeScale.sm)),
                          Text(
                            timeAgo,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: responsive.space(SizeScale.sm)),

                      // Report summary
                      Text(
                        report.kronologisKasus,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: responsive.space(SizeScale.md)),

                      // Address section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: responsive.space(SizeScale.md),
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: responsive.space(SizeScale.sm)),
                          Expanded(
                            child: Text(
                              report.alamatTkp,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: responsive.space(SizeScale.sm)),

                      // Registration number
                      Row(
                        children: [
                          Icon(
                            Icons.numbers,
                            size: responsive.space(SizeScale.md),
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: responsive.space(SizeScale.sm)),
                          Text(
                            report.noRegistrasi,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
