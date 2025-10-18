import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// iOS风格对话框辅助类
class IOSDialog {
  // 显示iOS样式的提示对话框
  static Future<void> showAlert({
    required BuildContext context,
    String? title,
    String? content,
    String okText = 'OK',
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(okText),
          ),
        ],
      ),
    );
  }

  // 显示iOS样式的确认对话框
  static Future<bool> showConfirm({
    required BuildContext context,
    String? title,
    String? content,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    bool isDestructive = false,
  }) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // 显示iOS样式的操作表
  static Future<T?> showActionSheet<T>({
    required BuildContext context,
    String? title,
    String? message,
    required List<ActionSheetItem<T>> actions,
    String? cancelText,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: title != null ? Text(title) : null,
        message: message != null ? Text(message) : null,
        actions: actions
            .map(
              (item) => CupertinoActionSheetAction(
                onPressed: () => Navigator.of(ctx).pop(item.value),
                isDestructiveAction: item.isDestructive,
                child: Text(item.label),
              ),
            )
            .toList(),
        cancelButton: cancelText != null
            ? CupertinoActionSheetAction(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(cancelText),
              )
            : null,
      ),
    );
  }
}

// 操作表项目
class ActionSheetItem<T> {
  final String label;
  final T value;
  final bool isDestructive;

  const ActionSheetItem({
    required this.label,
    required this.value,
    this.isDestructive = false,
  });
}
