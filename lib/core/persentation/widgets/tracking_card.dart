import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/screen_navigator.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/custom_icon.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/modals/image_modal.dart';
import 'package:pa2_kelompok07/model/report/tracking_report_model.dart';
import 'package:pa2_kelompok07/styles/color.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingCardAdmin extends StatelessWidget {
  final TrackingLaporanModel tracking;
  final bool isLatest;
  final int position;
  final int totalSteps;
  final VoidCallback? onTap;
  final bool isAdmin;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  const TrackingCardAdmin({
    super.key,
    required this.tracking,
    this.isLatest = false,
    required this.position,
    required this.totalSteps,
    this.onTap,
    this.isAdmin = false,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(
          horizontal: responsive.space(SizeScale.md),
          vertical: responsive.space(SizeScale.sm),
        ),
        padding: EdgeInsets.all(responsive.space(SizeScale.md)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.sm),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color:
                isLatest
                    ? AppColors.primary.withOpacity(0.3)
                    : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomStepper(context),
            SizedBox(width: responsive.space(SizeScale.md)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat(
                          'dd MMM yyyy, HH:mm',
                        ).format(tracking.updatedAt),
                        style: textStyle.jakartaSansMedium(
                          size: SizeScale.sm,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (isAdmin)
                        PopupMenuButton(
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'update',
                                  child: Text('Update'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                          onSelected: (value) {
                            if (value == 'update') onUpdate?.call();
                            if (value == 'delete') onDelete?.call();
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: responsive.space(SizeScale.sm)),
                  Text(
                    tracking.keterangan,
                    style: textStyle.onestBold(
                      size: SizeScale.md,
                      color: Colors.black87,
                    ),
                  ),
                  if (tracking.documents.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                        top: responsive.space(SizeScale.sm),
                      ),
                      child: _buildDocumentsPreview(context),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomStepper(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;

    return Column(
      children: [
        if (position > 1) // Draw line above if not first
          Container(
            width: 2,
            height: responsive.space(SizeScale.lg),
            color: AppColors.primary.withOpacity(0.3),
          ),
        Container(
          width: responsive.space(SizeScale.lg),
          height: responsive.space(SizeScale.lg),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isLatest ? AppColors.primary : Colors.grey[300],
            border: Border.all(
              color: isLatest ? AppColors.primary : Colors.grey[400]!,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '$position',
              style: textStyle.onestBold(
                size: SizeScale.sm,
                color: isLatest ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        ),
        if (position < totalSteps) // Draw line below if not last
          Container(
            width: 2,
            height: responsive.space(SizeScale.lg),
            color: AppColors.primary.withOpacity(0.3),
          ),
      ],
    );
  }

  Widget _buildDocumentsPreview(BuildContext context) {
    final responsive = context.responsive;
    return SizedBox(
      height: responsive.space(SizeScale.xxl),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tracking.documents.length,
        itemBuilder:
            (context, index) => Padding(
              padding: EdgeInsets.only(right: responsive.space(SizeScale.sm)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(SizeScale.xs),
                ),
                child: GestureDetector(
                  onTap: () {
                    ScreenNavigator(cx: context).navigate(
                      FlutterFlowExpandedImageView(
                        image: CachedNetworkImage(
                          imageUrl: tracking.documents[index],

                          fit: BoxFit.contain,
                        ),
                        allowRotation: false,
                        tag: tracking.documents[index],
                        useHeroAnimation: true,
                      ),
                      NavigatorTweens.rightToLeft(),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: tracking.documents[index],
                    width: responsive.space(SizeScale.xxl),
                    height: responsive.space(SizeScale.xxl),
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => const CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}

class TrackingCard extends StatelessWidget {
  final TrackingLaporanModel tracking;
  final bool isLatest;
  final VoidCallback? onTap;

  const TrackingCard({
    super.key,
    required this.tracking,
    this.isLatest = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(
        bottom: responsive.space(SizeScale.sm),
        left: responsive.space(SizeScale.md),
        right: responsive.space(SizeScale.md),
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(
          responsive.borderRadius(SizeScale.sm),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.sm),
          ),
          child: Padding(
            padding: EdgeInsets.all(responsive.space(SizeScale.md)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with time and status indicator
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator
                    _buildTimelineIndicator(context),
                    SizedBox(width: responsive.space(SizeScale.md)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time and latest badge
                          Row(
                            children: [
                              Text(
                                DateFormat('HH:mm').format(tracking.updatedAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              if (isLatest) ...[
                                SizedBox(width: responsive.space(SizeScale.xs)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsive.space(SizeScale.xs),
                                    vertical:
                                        responsive.space(SizeScale.xs) / 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      responsive.borderRadius(SizeScale.xs),
                                    ),
                                  ),
                                  child: Text(
                                    'TERBARU',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: responsive.space(SizeScale.xs)),
                          // Tracking description
                          Text(
                            tracking.keterangan,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Documents section
                if (tracking.documents.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                      left: responsive.space(SizeScale.xxl),
                      top: responsive.space(SizeScale.sm),
                    ),
                    child: _buildDocumentsSection(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineIndicator(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 2,
          height: responsive.space(SizeScale.sm),
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: responsive.space(SizeScale.md),
          height: responsive.space(SizeScale.md),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isLatest
                    ? AppColors.primary
                    : theme.colorScheme.primaryContainer,
            border: Border.all(
              color:
                  isLatest
                      ? AppColors.primary.withOpacity(0.3)
                      : theme.colorScheme.outline.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            isLatest ? Icons.check_circle : Icons.circle,
            size: responsive.fontSize(SizeScale.sm),
            color:
                isLatest ? Colors.white : theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    // final validDocuments = tracking.documents;
    final validDocuments =
        tracking.documents.where((url) => _isValidUrl(url)).toList();

    if (validDocuments.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dokumen Pendukung:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        SizedBox(height: responsive.space(SizeScale.xs)),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: validDocuments.length > 1 ? 2 : 1,
            crossAxisSpacing: responsive.space(SizeScale.xs),
            mainAxisSpacing: responsive.space(SizeScale.xs),
            childAspectRatio: 1.5,
          ),
          itemCount: validDocuments.length,
          itemBuilder: (context, index) {
            final url = validDocuments[index];
            return _buildDocumentItem(context, url);
          },
        ),
      ],
    );
  }

  Widget _buildDocumentItem(BuildContext context, String url) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _handleDocumentTap(context, url),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.xs),
          ),
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.xs),
          ),
          child: Stack(
            children: [
              if (url.endsWith('.pdf'))
                _buildPdfPreview(context, url)
              else
                _buildImagePreview(context, url),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(responsive.space(SizeScale.xs)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        url.endsWith('.pdf')
                            ? Icons.picture_as_pdf
                            : Icons.image,
                        size: responsive.fontSize(SizeScale.sm),
                        color: Colors.white,
                      ),
                      SizedBox(width: responsive.space(SizeScale.xs)),
                      Expanded(
                        child: Text(
                          url.endsWith('.pdf') ? 'PDF Document' : 'Image',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfPreview(BuildContext context, String url) {
    final responsive = context.responsive;

    return Container(
      color: AppColors.error.withOpacity(0.1),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            size: responsive.fontSize(SizeScale.xxl),
            color: AppColors.error,
          ),
          SizedBox(height: responsive.space(SizeScale.xs)),
          Text(
            'PDF File',
            style: TextStyle(
              fontSize: responsive.fontSize(SizeScale.sm),
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder:
          (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          ),
      errorWidget:
          (context, url, error) => Container(
            color: Colors.grey[200],
            child: Center(
              child: CustomIconButton(
                icon: Icons.broken_image,
                iconSize: context.responsive.fontSize(SizeScale.xxl),
                color: AppColors.error,
              ),
            ),
          ),
    );
  }

  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      return Uri.parse(url).isAbsolute;
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleDocumentTap(BuildContext context, String url) async {
    if (url.endsWith('.pdf')) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      ScreenNavigator(cx: context).navigate(
        FlutterFlowExpandedImageView(
          image: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
          allowRotation: false,
          tag: url,
          useHeroAnimation: true,
        ),
        NavigatorTweens.rightToLeft(),
      );
    }
  }
}
