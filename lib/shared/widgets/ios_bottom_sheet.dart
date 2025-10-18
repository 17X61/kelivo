import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../theme/ios_animations.dart';

// iOS风格的底部表单
class IOSBottomSheet {
  // 显示iOS样式的底部表单
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (ctx) => _IOSBottomSheetContainer(
        builder: builder,
        backgroundColor: backgroundColor,
      ),
    );
  }

  // 显示可滚动的iOS样式底部表单
  static Future<T?> showScrollable<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    double? initialChildSize,
    double? minChildSize,
    double? maxChildSize,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: initialChildSize ?? 0.5,
        minChildSize: minChildSize ?? 0.25,
        maxChildSize: maxChildSize ?? 0.9,
        builder: (ctx, scrollController) => _IOSBottomSheetContainer(
          builder: builder,
          backgroundColor: backgroundColor,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

// iOS底部表单容器
class _IOSBottomSheetContainer extends StatelessWidget {
  final WidgetBuilder builder;
  final Color? backgroundColor;
  final ScrollController? scrollController;

  const _IOSBottomSheetContainer({
    required this.builder,
    this.backgroundColor,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom + mediaQuery.padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? 
            CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖动指示器
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey3,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              // 内容
              if (scrollController != null)
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: builder(context),
                  ),
                )
              else
                builder(context),
            ],
          ),
        ),
      ),
    );
  }
}

// iOS风格的模态底部表单（全屏）
class IOSModalSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final VoidCallback? onClose;

  const IOSModalSheet({
    super.key,
    required this.child,
    this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: title != null ? Text(title!) : null,
        trailing: onClose != null || Navigator.of(context).canPop()
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onClose ?? () => Navigator.of(context).pop(),
                child: const Text('完成'),
              )
            : null,
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool fullscreenDialog = true,
  }) {
    return Navigator.of(context).push<T>(
      CupertinoPageRoute<T>(
        builder: (ctx) => IOSModalSheet(
          title: title,
          child: child,
        ),
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }
}
