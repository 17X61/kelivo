import 'package:flutter/material.dart';
import '../../core/sizes.dart';

/// Desktop context menu item
class DesktopContextMenuItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isDivider;
  final bool isDestructive;
  final List<DesktopContextMenuItem>? submenu;
  final bool enabled;

  const DesktopContextMenuItem({
    this.label = '',
    this.icon,
    this.onTap,
    this.isDivider = false,
    this.isDestructive = false,
    this.submenu,
    this.enabled = true,
  });

  const DesktopContextMenuItem.divider()
      : label = '',
        icon = null,
        onTap = null,
        isDivider = true,
        isDestructive = false,
        submenu = null,
        enabled = true;
}

/// Show desktop context menu at cursor position
Future<T?> showDesktopContextMenu<T>({
  required BuildContext context,
  required Offset position,
  required List<DesktopContextMenuItem> items,
  double? width,
}) {
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final RelativeRect positionRect = RelativeRect.fromRect(
    Rect.fromLTWH(position.dx, position.dy, 0, 0),
    Offset.zero & overlay.size,
  );

  return showMenu<T>(
    context: context,
    position: positionRect,
    items: _buildMenuItems<T>(context, items),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
    ),
    elevation: 8,
  );
}

List<PopupMenuEntry<T>> _buildMenuItems<T>(
  BuildContext context,
  List<DesktopContextMenuItem> items,
) {
  final List<PopupMenuEntry<T>> entries = [];
  
  for (int i = 0; i < items.length; i++) {
    final item = items[i];
    
    if (item.isDivider) {
      entries.add(const PopupMenuDivider());
      continue;
    }
    
    entries.add(
      PopupMenuItem<T>(
        enabled: item.enabled,
        onTap: item.onTap,
        child: _ContextMenuItemWidget(item: item),
      ),
    );
  }
  
  return entries;
}

class _ContextMenuItemWidget extends StatelessWidget {
  final DesktopContextMenuItem item;

  const _ContextMenuItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = item.enabled
        ? (item.isDestructive ? colorScheme.error : colorScheme.onSurface)
        : colorScheme.onSurface.withOpacity(0.38);

    return Row(
      children: [
        if (item.icon != null) ...[
          Icon(
            item.icon,
            size: 18,
            color: textColor,
          ),
          SizedBox(width: AppSizes.lg),
        ],
        Expanded(
          child: Text(
            item.label,
            style: TextStyle(
              fontSize: AppSizes.fontSize14,
              color: textColor,
            ),
          ),
        ),
        if (item.submenu != null) ...[
          SizedBox(width: AppSizes.md),
          Icon(
            Icons.chevron_right,
            size: 16,
            color: textColor,
          ),
        ],
      ],
    );
  }
}

/// Widget wrapper that shows context menu on right click
class DesktopContextMenuRegion extends StatelessWidget {
  final Widget child;
  final List<DesktopContextMenuItem> items;
  final bool enabled;

  const DesktopContextMenuRegion({
    super.key,
    required this.child,
    required this.items,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled || items.isEmpty) {
      return child;
    }

    return GestureDetector(
      onSecondaryTapDown: (details) {
        showDesktopContextMenu(
          context: context,
          position: details.globalPosition,
          items: items,
        );
      },
      child: child,
    );
  }
}

/// Dropdown menu button for desktop (alternative to bottom sheet)
class DesktopDropdownMenuButton<T> extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final T? value;
  final List<DesktopDropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final double? width;

  const DesktopDropdownMenuButton({
    super.key,
    this.label,
    this.icon,
    this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<T>(
      initialValue: value,
      tooltip: label,
      onSelected: onChanged,
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<T>(
            value: item.value,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(item.icon, size: 18, color: colorScheme.onSurface),
                  SizedBox(width: AppSizes.lg),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: AppSizes.fontSize14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (item.trailing != null) item.trailing!,
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: colorScheme.onSurface),
              SizedBox(width: AppSizes.md),
            ],
            if (label != null)
              Text(
                label!,
                style: TextStyle(
                  fontSize: AppSizes.fontSize14,
                  color: colorScheme.onSurface,
                ),
              )
            else if (hint != null && value == null)
              Text(
                hint!,
                style: TextStyle(
                  fontSize: AppSizes.fontSize14,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopDropdownMenuItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final Widget? trailing;

  const DesktopDropdownMenuItem({
    required this.value,
    required this.label,
    this.icon,
    this.trailing,
  });
}
