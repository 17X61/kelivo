import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// iOS风格的主要按钮
class IOSButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double? minSize;
  final double? pressedOpacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isDestructive;

  const IOSButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.minSize,
    this.pressedOpacity,
    this.borderRadius,
    this.padding,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isDestructive 
        ? CupertinoColors.destructiveRed 
        : (color ?? CupertinoTheme.of(context).primaryColor);
    
    return CupertinoButton(
      onPressed: onPressed,
      color: effectiveColor,
      minSize: minSize ?? 44.0,
      pressedOpacity: pressedOpacity ?? 0.4,
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(color: textColor ?? CupertinoColors.white),
      ),
    );
  }
}

// iOS风格的文本按钮
class IOSTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final double? minSize;
  final double? pressedOpacity;
  final EdgeInsetsGeometry? padding;

  const IOSTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.minSize,
    this.pressedOpacity,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      minSize: minSize ?? 44.0,
      pressedOpacity: pressedOpacity ?? 0.4,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(
          color: color ?? CupertinoTheme.of(context).primaryColor,
        ),
      ),
    );
  }
}

// iOS风格的图标按钮
class IOSIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final double? minSize;
  final double? pressedOpacity;
  final EdgeInsetsGeometry? padding;

  const IOSIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size,
    this.minSize,
    this.pressedOpacity,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      minSize: minSize ?? 44.0,
      pressedOpacity: pressedOpacity ?? 0.4,
      padding: padding ?? EdgeInsets.zero,
      child: Icon(
        icon,
        color: color ?? CupertinoTheme.of(context).primaryColor,
        size: size ?? 24.0,
      ),
    );
  }
}

// iOS风格的填充按钮（带边框）
class IOSFilledButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? minSize;
  final double? pressedOpacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const IOSFilledButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.minSize,
    this.pressedOpacity,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      minSize: minSize ?? 44.0,
      pressedOpacity: pressedOpacity ?? 0.4,
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      color: backgroundColor,
      child: Container(
        decoration: borderColor != null
            ? BoxDecoration(
                border: Border.all(color: borderColor!),
                borderRadius: borderRadius ?? BorderRadius.circular(8.0),
              )
            : null,
        child: child,
      ),
    );
  }
}
