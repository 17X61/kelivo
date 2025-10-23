import 'package:flutter/material.dart';
import '../../core/platform_extension.dart';
import '../../core/sizes.dart';

/// Platform-adaptive dialog that shows as modal bottom sheet on mobile
/// and as dialog on desktop
Future<T?> showPlatformDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget>? actions,
  bool barrierDismissible = true,
}) {
  if (PlatformExtension.isDesktop) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: actions,
      ),
    );
  } else {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: barrierDismissible,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSizes.xl,
              right: AppSizes.xl,
              top: AppSizes.lg,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.lg),
                
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppSizes.fontSize18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.lg),
                
                // Content
                content,
                
                // Actions
                if (actions != null && actions.isNotEmpty) ...[
                  SizedBox(height: AppSizes.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Platform-adaptive selection sheet/menu
Future<T?> showPlatformSelector<T>({
  required BuildContext context,
  required String title,
  required List<PlatformSelectorItem<T>> items,
  T? currentValue,
}) {
  if (PlatformExtension.isDesktop) {
    // Desktop: Show as dialog with list
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item.value == currentValue;
              
              return ListTile(
                leading: item.icon != null
                    ? Icon(item.icon, size: 20)
                    : null,
                title: Text(item.label),
                subtitle: item.subtitle != null
                    ? Text(item.subtitle!)
                    : null,
                trailing: isSelected
                    ? const Icon(Icons.check, size: 20)
                    : null,
                selected: isSelected,
                onTap: () {
                  Navigator.of(context).pop(item.value);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  } else {
    // Mobile: Show as bottom sheet
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Padding(
                padding: EdgeInsets.only(top: AppSizes.lg),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              
              // Title
              Padding(
                padding: EdgeInsets.all(AppSizes.xl),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: AppSizes.fontSize18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // Items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item.value == currentValue;
                  
                  return ListTile(
                    leading: item.icon != null
                        ? Icon(item.icon, size: 24)
                        : null,
                    title: Text(item.label),
                    subtitle: item.subtitle != null
                        ? Text(item.subtitle!)
                        : null,
                    trailing: isSelected
                        ? const Icon(Icons.check, size: 24)
                        : null,
                    selected: isSelected,
                    onTap: () {
                      Navigator.of(context).pop(item.value);
                    },
                  );
                },
              ),
              SizedBox(height: AppSizes.xl),
            ],
          ),
        );
      },
    );
  }
}

class PlatformSelectorItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;

  const PlatformSelectorItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}

/// Show confirmation dialog with platform-specific styling
Future<bool> showPlatformConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  bool isDestructive = false,
}) async {
  final result = await showPlatformDialog<bool>(
    context: context,
    title: title,
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(cancelText ?? 'Cancel'),
      ),
      FilledButton(
        style: isDestructive
            ? FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              )
            : null,
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(confirmText ?? 'Confirm'),
      ),
    ],
  );
  
  return result ?? false;
}

/// Show input dialog with platform-specific styling
Future<String?> showPlatformInputDialog({
  required BuildContext context,
  required String title,
  String? hint,
  String? initialValue,
  String? confirmText,
  String? cancelText,
  int? maxLines,
}) {
  final controller = TextEditingController(text: initialValue);

  return showPlatformDialog<String>(
    context: context,
    title: title,
    content: TextField(
      controller: controller,
      autofocus: true,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        hintText: hint,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(cancelText ?? 'Cancel'),
      ),
      FilledButton(
        onPressed: () {
          Navigator.of(context).pop(controller.text);
        },
        child: Text(confirmText ?? 'OK'),
      ),
    ],
  );
}
