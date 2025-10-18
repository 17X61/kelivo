import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// iOS风格的列表项
class IOSListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool showChevron;

  const IOSListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.padding,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      color: backgroundColor ?? CupertinoColors.secondarySystemGroupedBackground,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 17,
                    color: CupertinoColors.label,
                  ),
                  child: title,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 15,
                      color: CupertinoColors.secondaryLabel,
                    ),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
          if (showChevron)
            const Icon(
              CupertinoIcons.chevron_right,
              size: 20,
              color: CupertinoColors.systemGrey3,
            ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}

// iOS风格的分组列表
class IOSListSection extends StatelessWidget {
  final String? header;
  final String? footer;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  const IOSListSection({
    super.key,
    this.header,
    this.footer,
    required this.children,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: header != null ? Text(header!) : null,
      footer: footer != null ? Text(footer!) : null,
      backgroundColor: backgroundColor,
      margin: margin,
      children: children,
    );
  }
}

// iOS风格的卡片
class IOSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const IOSCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? CupertinoColors.secondarySystemGroupedBackground,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

// iOS风格的分隔线
class IOSDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const IOSDivider({
    super.key,
    this.height,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 0.5,
      margin: EdgeInsets.only(
        left: indent ?? 0,
        right: endIndent ?? 0,
      ),
      color: color ?? CupertinoColors.separator,
    );
  }
}
