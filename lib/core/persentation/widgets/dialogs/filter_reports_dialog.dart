import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/provider/admin_provider.dart';

class ReportFilterDropdown extends StatefulWidget {
  final AdminProvider adminProvider;
  final VoidCallback onFilterApplied;

  const ReportFilterDropdown({
    required this.adminProvider,
    required this.onFilterApplied,
    super.key,
  });

  @override
  State<ReportFilterDropdown> createState() => _ReportFilterDropdownState();
}

class _ReportFilterDropdownState extends State<ReportFilterDropdown>
    with SingleTickerProviderStateMixin {
  String? _selectedStatusSort;
  bool _sortByDateAsc = true;
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  void _showDropdown(BuildContext context) {
    if (_overlayEntry != null) return; // Cegah multiple overlay

    final responsive = context.responsive;
    final textStyle = context.textStyle;
    final theme = Theme.of(context);

    _controller.reset();
    _overlayEntry = OverlayEntry(
      builder:
          (context) => GestureDetector(
            onTap: _closeDropdown,
            behavior: HitTestBehavior.translucent,
            child: Material(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: EdgeInsets.all(responsive.space(SizeScale.md)),
                      constraints: BoxConstraints(
                        maxWidth: responsive.widthPercent(90),
                        maxHeight: responsive.heightPercent(60),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(SizeScale.md),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sort Reports',
                                  style: textStyle.onestBold(
                                    size: SizeScale.lg,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: responsive.fontSize(SizeScale.md),
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: _closeDropdown,
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.space(SizeScale.md)),
                            // Status Sort Section
                            _buildSectionHeader(
                              context: context,
                              icon: Icons.sort_by_alpha_rounded,
                              title: 'Group by Status',
                            ),
                            SizedBox(height: responsive.space(SizeScale.sm)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.space(SizeScale.sm),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(
                                  responsive.borderRadius(SizeScale.sm),
                                ),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _selectedStatusSort,
                                  hint: Text(
                                    'Select status to group',
                                    style: textStyle.dmSansRegular(
                                      size: SizeScale.sm,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: null,
                                      child: Text(
                                        'No Grouping',
                                        style: textStyle.dmSansRegular(
                                          size: SizeScale.sm,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                    ...[
                                      'DiProses',
                                      'Selesai',
                                      'Dibatalkan',
                                      'Dilihat',
                                    ].map(
                                      (status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(
                                          status,
                                          style: textStyle.dmSansRegular(
                                            size: SizeScale.sm,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() => _selectedStatusSort = value);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: responsive.space(SizeScale.md)),
                            // Date Sort Section
                            _buildSectionHeader(
                              context: context,
                              icon: Icons.date_range_rounded,
                              title: 'Sort by Date',
                            ),
                            SizedBox(height: responsive.space(SizeScale.sm)),
                            Container(
                              padding: EdgeInsets.all(
                                responsive.space(SizeScale.sm),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(
                                  responsive.borderRadius(SizeScale.sm),
                                ),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sort by Date (${_sortByDateAsc ? 'Oldest First' : 'Newest First'})',
                                    style: textStyle.dmSansRegular(
                                      size: SizeScale.sm,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: _sortByDateAsc,
                                      onChanged: (value) {
                                        setState(() => _sortByDateAsc = value);
                                      },
                                      activeColor: theme.primaryColor,
                                      activeTrackColor: theme.primaryColor
                                          .withOpacity(0.3),
                                      inactiveThumbColor: Colors.grey[600],
                                      inactiveTrackColor: Colors.grey[300],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: responsive.space(SizeScale.lg)),
                            // Apply Button
                            ElevatedButton(
                              onPressed: () {
                                widget.adminProvider.sortReports(
                                  groupByStatus: _selectedStatusSort,
                                  sortByDateAsc: _sortByDateAsc,
                                );
                                widget.onFilterApplied();
                                _closeDropdown();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                minimumSize: Size(
                                  double.infinity,
                                  responsive.space(SizeScale.lg),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    responsive.borderRadius(SizeScale.sm),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Apply Sort',
                                style: textStyle.jakartaSansMedium(
                                  size: SizeScale.sm,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  Widget _buildSectionHeader({
    required BuildContext context,
    required IconData icon,
    required String title,
  }) {
    final textStyle = context.textStyle;
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: responsive.fontSize(SizeScale.md),
          color: theme.primaryColor,
        ),
        SizedBox(width: responsive.space(SizeScale.sm)),
        Text(
          title,
          style: textStyle.jakartaSansMedium(
            size: SizeScale.md,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final responsive = context.responsive;
            final textStyle = context.textStyle;
            final theme = Theme.of(context);

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(SizeScale.md),
                ),
              ),

              child: Container(
                padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                constraints: BoxConstraints(
                  maxWidth: responsive.widthPercent(80),
                  maxHeight: responsive.heightPercent(60),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sort Reports',
                            style: textStyle.onestBold(
                              size: SizeScale.lg,
                              color: theme.primaryColor,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: responsive.fontSize(SizeScale.md),
                              color: Colors.grey[600],
                            ),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.space(SizeScale.md)),
                      // Status Sort Section
                      _buildSectionHeader(
                        context: context,
                        icon: Icons.sort_by_alpha_rounded,
                        title: 'Group by Status',
                      ),
                      SizedBox(height: responsive.space(SizeScale.sm)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.space(SizeScale.sm),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(SizeScale.sm),
                          ),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedStatusSort,
                            hint: Text(
                              'Select status to group',
                              style: textStyle.dmSansRegular(
                                size: SizeScale.sm,
                                color: Colors.grey[600],
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(
                                  'No Grouping',
                                  style: textStyle.dmSansRegular(
                                    size: SizeScale.sm,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              ...[
                                'Laporan Masuk',
                                'Dilihat',
                                'Diproses',
                                'Selesai',
                                'Dibatalkan',
                              ].map(
                                (status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(
                                    status,
                                    style: textStyle.dmSansRegular(
                                      size: SizeScale.sm,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setDialogState(() {
                                _selectedStatusSort = value;
                              });
                              setState(() {
                                _selectedStatusSort = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: responsive.space(SizeScale.md)),
                      // Date Sort Section
                      _buildSectionHeader(
                        context: context,
                        icon: Icons.date_range_rounded,
                        title: 'Sort by Date',
                      ),
                      SizedBox(height: responsive.space(SizeScale.sm)),
                      Container(
                        padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(SizeScale.sm),
                          ),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Sort by Date ',
                                  style: textStyle.dmSansRegular(
                                    size: SizeScale.sm,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  '(${_sortByDateAsc ? 'Oldest First' : 'Newest First'})',
                                  style: textStyle.dmSansRegular(
                                    size: SizeScale.sm,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: _sortByDateAsc,
                                onChanged: (value) {
                                  setDialogState(() {
                                    _sortByDateAsc = value;
                                  });
                                  setState(() {
                                    _sortByDateAsc = value;
                                  });
                                },
                                activeColor: theme.primaryColor,
                                activeTrackColor: theme.primaryColor
                                    .withOpacity(0.3),
                                inactiveThumbColor: Colors.grey[600],
                                inactiveTrackColor: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: responsive.space(SizeScale.lg)),
                      // Apply Button
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                widget.adminProvider.filterOrSortReports(
                                  statusFilter: _selectedStatusSort,
                                  sortByDateAsc: _sortByDateAsc,
                                );
                                widget.onFilterApplied();
                                _closeDropdown();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: responsive.space(SizeScale.sm),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    responsive.borderRadius(SizeScale.sm),
                                  ),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Apply Filters',
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
              ),
            );
          },
        );
      },
    );
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _controller.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Tooltip(
      message: 'Filters',
      child: InkWell(
        borderRadius: BorderRadius.circular(
          responsive.borderRadius(SizeScale.md),
        ),
        onTap: () => _showSortDialog(context),
        child: Container(
          padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              responsive.borderRadius(SizeScale.md),
            ),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: responsive.fontSize(SizeScale.md),
                color: Color(0xFF79B2E1),
              ),
              SizedBox(width: responsive.space(SizeScale.xs)),
              Text(
                'Filter',
                style: context.textStyle.jakartaSansMedium(
                  size: SizeScale.sm,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
