import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// iOS风格页面路由辅助类
class IOSPageRoute {
  // 使用iOS样式路由推送页面
  static Future<T?> push<T>(
    BuildContext context,
    Widget page, {
    bool fullscreenDialog = false,
  }) {
    return Navigator.of(context).push<T>(
      CupertinoPageRoute<T>(
        builder: (_) => page,
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }

  // iOS样式的模态路由
  static Future<T?> pushModal<T>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).push<T>(
      CupertinoPageRoute<T>(
        builder: (_) => page,
        fullscreenDialog: true,
      ),
    );
  }

  // 替换当前页面
  static Future<T?> pushReplacement<T, TO>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).pushReplacement<T, TO>(
      CupertinoPageRoute<T>(
        builder: (_) => page,
      ),
    );
  }

  // 推送并移除直到条件满足
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget page,
    bool Function(Route<dynamic>) predicate,
  ) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      CupertinoPageRoute<T>(
        builder: (_) => page,
      ),
      predicate,
    );
  }

  // 创建iOS风格的PageRoute
  static PageRoute<T> createRoute<T>(Widget page, {bool fullscreenDialog = false}) {
    return CupertinoPageRoute<T>(
      builder: (_) => page,
      fullscreenDialog: fullscreenDialog,
    );
  }

  // 创建iOS风格的Modal弹窗路由
  static Route<T> createModalRoute<T>(Widget page) {
    return CupertinoModalPopupRoute<T>(
      builder: (_) => page,
    );
  }
}
