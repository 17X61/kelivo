import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// iOS风格的Scaffold，同时支持Material组件兼容
class IOSScaffold extends StatelessWidget {
  final Widget? navigationBar;
  final Widget body;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const IOSScaffold({
    super.key,
    this.navigationBar,
    required this.body,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    // 使用CupertinoPageScaffold作为基础
    return CupertinoPageScaffold(
      navigationBar: navigationBar as ObstructingPreferredSizeWidget?,
      backgroundColor: backgroundColor ?? CupertinoTheme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      child: body,
    );
  }
}

// iOS风格的导航栏
class IOSNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Brightness? brightness;
  final bool transitionBetweenRoutes;
  final Object? heroTag;
  final Border? border;

  const IOSNavigationBar({
    super.key,
    this.leading,
    this.middle,
    this.trailing,
    this.actions,
    this.backgroundColor,
    this.brightness,
    this.transitionBetweenRoutes = true,
    this.heroTag,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    // 如果有多个actions，组合成一个Row
    Widget? finalTrailing = trailing;
    if (actions != null && actions!.isNotEmpty) {
      finalTrailing = Row(
        mainAxisSize: MainAxisSize.min,
        children: actions!,
      );
    }

    return CupertinoNavigationBar(
      leading: leading,
      middle: middle,
      trailing: finalTrailing,
      backgroundColor: backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor,
      brightness: brightness,
      transitionBetweenRoutes: transitionBetweenRoutes,
      heroTag: heroTag ?? 'IOSNavigationBar',
      border: border ?? const Border(bottom: BorderSide(color: Color(0x4D000000), width: 0.0)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = this.backgroundColor ?? 
        CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}
