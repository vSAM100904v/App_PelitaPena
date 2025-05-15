import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/models/notification_channel_model.dart';
import 'package:pa2_kelompok07/core/utils/notification_type_util.dart';

class NotificationCard extends StatefulWidget {
  final String title;
  final NotificationType type;
  final DateTime time;
  final bool isRead;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.type,
    required this.time,
    required this.isRead,
    required this.onTap,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late bool _isNotificationRead;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    _isNotificationRead = widget.isRead;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _backgroundColorAnimation = ColorTween(
      begin: Colors.transparent,
      end:
          widget.isRead
              ? Color(0xFFFFF7F7)
              : Color(0xFFFFF7F7).withOpacity(0.05),
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant NotificationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRead != widget.isRead) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 30) {
      return DateFormat('dd MMM yyyy').format(time);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }

  void markAsRead() {
    print('Mark as read di triggered');
    if (!_isNotificationRead) {
      setState(() {
        _isNotificationRead = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: responsive.space(SizeScale.xs),
          horizontal: responsive.space(SizeScale.sm),
        ),
        decoration: BoxDecoration(
          color: _backgroundColorAnimation.value,
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.md),
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(_isNotificationRead ? 0.05 : 0.1),
          //     blurRadius: .5,
          //     // offset: const Offset(0, 1),
          //   ),
          // ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              markAsRead();
              widget.onTap();
            },
            borderRadius: BorderRadius.circular(
              responsive.borderRadius(SizeScale.md),
            ),
            splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            highlightColor: Colors.transparent,
            child: Stack(
              children: [
                if (!_isNotificationRead)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: NotificationTypeUtils.getColor(widget.type),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            responsive.borderRadius(SizeScale.md),
                          ),
                          bottomLeft: Radius.circular(
                            responsive.borderRadius(SizeScale.md),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: responsive.space(SizeScale.md)),
                Padding(
                  padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          key: ValueKey<bool>(_isNotificationRead),
                          width: responsive.space(SizeScale.xxl),
                          height: responsive.space(SizeScale.xxl),
                          decoration: BoxDecoration(
                            color: NotificationTypeUtils.getColor(
                              widget.type,
                            ).withOpacity(_isNotificationRead ? 0.7 : 1.0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            NotificationTypeUtils.getIcon(widget.type),
                            color: Colors.white,
                            size: responsive.fontSize(SizeScale.lg),
                          ),
                        ),
                      ),

                      SizedBox(width: responsive.space(SizeScale.md)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: NotificationText(
                                    title: widget.title,
                                    isRead: _isNotificationRead,
                                  ),
                                ),
                                if (!_isNotificationRead)
                                  Container(
                                    padding: EdgeInsets.all(
                                      responsive.space(SizeScale.xs),
                                    ),
                                    decoration: BoxDecoration(
                                      color: NotificationTypeUtils.getColor(
                                        widget.type,
                                      ).withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.circle,
                                      size: responsive.space(SizeScale.xs),
                                      color: NotificationTypeUtils.getColor(
                                        widget.type,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: responsive.space(SizeScale.xs)),
                            Text(
                              NotificationTypeUtils.getSender(widget.type),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                            SizedBox(height: responsive.space(SizeScale.xs)),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: responsive.fontSize(SizeScale.sm),
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                                SizedBox(width: responsive.space(SizeScale.xs)),
                                Text(
                                  _formatTime(widget.time),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.5),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.chevron_right,
                                  size: responsive.fontSize(SizeScale.md),
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                ),
                              ],
                            ),
                          ],
                        ),
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

class NotificationText extends StatelessWidget {
  final String title;
  final bool isRead;

  const NotificationText({
    super.key,
    required this.title,
    required this.isRead,
  });

  String _cleanBrokenCharacters(String input) {
    final RegExp brokenCharsRegex = RegExp(r'[\uFFFD\u00F0\x00-\x1F]');
    return input.replaceAll(brokenCharsRegex, '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cleanedTitle = _cleanBrokenCharacters(title);

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style:
          theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color:
                isRead
                    ? theme.colorScheme.onSurface.withOpacity(0.8)
                    : theme.colorScheme.onSurface,
          ) ??
          TextStyle(),
      child: Text(cleanedTitle, maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }
}
