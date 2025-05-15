import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';

import 'package:pa2_kelompok07/styles/color.dart';

enum ClickedAction { copy, report, deleted }

class BottomSheetMenu extends StatefulWidget {
  final ValueChanged<ClickedAction> onAction;
  final String currentRole;
  final bool isSelfMessage;
  final bool isImage;

  const BottomSheetMenu({
    Key? key,
    required this.currentRole,
    required this.onAction,
    required this.isSelfMessage,
    required this.isImage,
  }) : super(key: key);

  @override
  _BottomSheetMenuState createState() => _BottomSheetMenuState();
}

class _BottomSheetMenuState extends State<BottomSheetMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  final DarkTheme _theme = DarkTheme();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            (1 - _slideAnimation.value) * context.responsive.heightPercent(50),
          ),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    context.responsive.borderRadius(SizeScale.sm),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: context.responsive.space(SizeScale.sm),
                    spreadRadius: context.responsive.space(SizeScale.xs),
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: context.responsive.widthPercent(10),
                    height: context.responsive.space(SizeScale.xs),
                    margin: EdgeInsets.symmetric(
                      vertical: context.responsive.space(SizeScale.sm),
                    ),
                    decoration: BoxDecoration(
                      color: _theme.replyPopupTopBorderColor,
                      borderRadius: BorderRadius.circular(
                        context.responsive.borderRadius(SizeScale.xs),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.copy_all_outlined,
                    text: widget.isImage ? "Copy URL" : 'Copy Text',
                    onTap: () {
                      Navigator.pop(context);
                      widget.onAction(ClickedAction.copy);
                    },
                    theme: _theme,
                  ),
                  if (widget.currentRole != "admin")
                    SizedBox(height: context.responsive.space(SizeScale.sm)),
                  _MenuItem(
                    icon: Icons.flag_outlined,
                    text: 'Report',
                    onTap: () {
                      Navigator.pop(context);
                      widget.onAction(ClickedAction.report);
                    },
                    theme: _theme,
                  ),

                  if (widget.isSelfMessage) ...[
                    SizedBox(height: context.responsive.space(SizeScale.md)),
                    _MenuItem(
                      icon: Icons.restore_from_trash_outlined,
                      text: 'Delete',
                      onTap: () {
                        Navigator.pop(context);
                        widget.onAction(ClickedAction.deleted);
                      },
                      theme: _theme,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MenuItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final DarkTheme theme;

  const _MenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
    required this.theme,
  });

  @override
  __MenuItemState createState() => __MenuItemState();
}

class __MenuItemState extends State<_MenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: context.responsive.space(SizeScale.sm),
            horizontal: context.responsive.space(SizeScale.md),
          ),
          margin: EdgeInsets.symmetric(
            horizontal: context.responsive.space(SizeScale.md),
          ),
          decoration: BoxDecoration(
            color:
                _isHovered ? widget.theme.replyPopupColor : Colors.transparent,
            borderRadius: BorderRadius.circular(
              context.responsive.borderRadius(SizeScale.xs),
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: context.responsive.space(SizeScale.lg),
                color:
                    _isHovered
                        ? widget.theme.replyPopupButtonColor
                        : widget.theme.appBarColor,
              ),
              SizedBox(width: context.responsive.space(SizeScale.sm)),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: context.responsive.fontSize(SizeScale.md),
                  color:
                      _isHovered
                          ? widget.theme.replyPopupButtonColor
                          : widget.theme.appBarColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
