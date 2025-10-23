import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// Desktop-style popup menu with blur background
/// 
/// Replaces bottom sheets on desktop with a more native-feeling popup menu
class DesktopPopupMenu extends StatelessWidget {
  const DesktopPopupMenu({
    super.key,
    required this.items,
    this.width = 220,
  });

  final List<DesktopPopupMenuItem> items;
  final double width;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : cs.outlineVariant.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1C1C1E).withOpacity(0.66)
                  : Colors.white.withOpacity(0.66),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Show popup menu at a specific position
  static Future<T?> show<T>({
    required BuildContext context,
    required List<DesktopPopupMenuItem> items,
    required Offset position,
    double width = 220,
  }) {
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (overlayBox == null) return Future.value(null);

    final screenSize = overlayBox.size;
    final insets = MediaQuery.of(context).padding;
    
    // Estimate menu height
    final estMenuHeight = items.length * 48.0 + 16.0;

    // Adjust position to keep menu on screen
    double x = position.dx;
    double y = position.dy;

    // Keep within horizontal bounds
    if (x + width > screenSize.width - insets.right - 12) {
      x = screenSize.width - insets.right - width - 12;
    }
    if (x < insets.left + 12) {
      x = insets.left + 12;
    }

    // Keep within vertical bounds
    if (y + estMenuHeight > screenSize.height - insets.bottom - 12) {
      y = y - estMenuHeight;
    }
    if (y < insets.top + 12) {
      y = insets.top + 12;
    }

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'popup-menu',
      barrierColor: Colors.black.withOpacity(0.08),
      pageBuilder: (ctx, _, __) {
        return Stack(
          children: [
            Positioned(
              left: x,
              top: y,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.95 + (0.05 * value),
                    alignment: Alignment.topLeft,
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: DesktopPopupMenu(
                  items: items,
                  width: width,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A single item in a desktop popup menu
class DesktopPopupMenuItem extends StatefulWidget {
  const DesktopPopupMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  final bool enabled;

  @override
  State<DesktopPopupMenuItem> createState() => _DesktopPopupMenuItemState();
}

class _DesktopPopupMenuItemState extends State<DesktopPopupMenuItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color textColor;
    if (!widget.enabled) {
      textColor = cs.onSurface.withOpacity(0.38);
    } else if (widget.danger) {
      textColor = Colors.red;
    } else {
      textColor = cs.onSurface;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: _hovering && widget.enabled
                ? (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04))
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: textColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
