import 'package:flutter/material.dart';

/// Desktop-style icon button with hover effect
/// 
/// Provides visual feedback when mouse hovers over the button,
/// which is a standard desktop UI pattern
class DesktopIconButton extends StatefulWidget {
  const DesktopIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 20,
    this.padding = const EdgeInsets.all(8),
    this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final EdgeInsets padding;
  final String? tooltip;
  final Color? color;

  @override
  State<DesktopIconButton> createState() => _DesktopIconButtonState();
}

class _DesktopIconButtonState extends State<DesktopIconButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = widget.color ?? cs.onSurface;

    Widget button = MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _hovering
                ? (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.icon,
            size: widget.size,
            color: iconColor,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}
