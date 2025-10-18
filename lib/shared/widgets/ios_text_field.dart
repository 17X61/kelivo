import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// iOS风格的文本输入框
class IOSTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final Widget? prefix;
  final Widget? suffix;
  final EdgeInsetsGeometry? padding;
  final bool enabled;
  final TextStyle? style;
  final TextStyle? placeholderStyle;
  final BoxDecoration? decoration;
  final TextCapitalization textCapitalization;

  const IOSTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.prefix,
    this.suffix,
    this.padding,
    this.enabled = true,
    this.style,
    this.placeholderStyle,
    this.decoration,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      prefix: prefix,
      suffix: suffix,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      enabled: enabled,
      style: style,
      placeholderStyle: placeholderStyle ?? TextStyle(
        color: CupertinoColors.placeholderText,
      ),
      decoration: decoration ?? BoxDecoration(
        color: CupertinoColors.tertiarySystemFill,
        borderRadius: BorderRadius.circular(10.0),
      ),
      textCapitalization: textCapitalization,
    );
  }
}

// iOS风格的搜索框
class IOSSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final VoidCallback? onSuffixTap;

  const IOSSearchField({
    super.key,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: controller,
      placeholder: placeholder,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      onSuffixTap: onSuffixTap,
    );
  }
}
