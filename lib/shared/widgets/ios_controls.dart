import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// iOS风格的开关
class IOSSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? trackColor;

  const IOSSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor ?? CupertinoColors.activeGreen,
      trackColor: trackColor,
    );
  }
}

// iOS风格的滑块
class IOSSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final Color? activeColor;
  final Color? thumbColor;

  const IOSSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.thumbColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSlider(
      value: value,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: divisions,
      activeColor: activeColor ?? CupertinoTheme.of(context).primaryColor,
      thumbColor: thumbColor ?? CupertinoColors.white,
    );
  }
}

// iOS风格的分段控制器
class IOSSegmentedControl<T> extends StatelessWidget {
  final T? groupValue;
  final Map<T, Widget> children;
  final ValueChanged<T?>? onValueChanged;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  const IOSSegmentedControl({
    super.key,
    this.groupValue,
    required this.children,
    this.onValueChanged,
    this.selectedColor,
    this.unselectedColor,
    this.borderColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<T>(
      groupValue: groupValue,
      children: children,
      onValueChanged: onValueChanged,
      backgroundColor: unselectedColor ?? CupertinoColors.tertiarySystemFill,
      thumbColor: selectedColor ?? CupertinoColors.white,
      padding: padding ?? const EdgeInsets.all(2),
    );
  }
}

// iOS风格的复选框（使用圆形开关样式）
class IOSCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const IOSCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value 
              ? (activeColor ?? CupertinoTheme.of(context).primaryColor)
              : (inactiveColor ?? CupertinoColors.systemGrey4),
          border: Border.all(
            color: value
                ? (activeColor ?? CupertinoTheme.of(context).primaryColor)
                : CupertinoColors.systemGrey3,
            width: 2,
          ),
        ),
        child: value
            ? const Icon(
                CupertinoIcons.check_mark,
                size: 14,
                color: CupertinoColors.white,
              )
            : null,
      ),
    );
  }
}

// iOS风格的单选按钮
class IOSRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const IOSRadio({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CupertinoColors.white,
          border: Border.all(
            color: isSelected
                ? (activeColor ?? CupertinoTheme.of(context).primaryColor)
                : CupertinoColors.systemGrey3,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeColor ?? CupertinoTheme.of(context).primaryColor,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

// iOS风格的活动指示器
class IOSActivityIndicator extends StatelessWidget {
  final double? radius;
  final Color? color;
  final bool animating;

  const IOSActivityIndicator({
    super.key,
    this.radius,
    this.color,
    this.animating = true,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: radius ?? 10.0,
      color: color,
      animating: animating,
    );
  }
}
