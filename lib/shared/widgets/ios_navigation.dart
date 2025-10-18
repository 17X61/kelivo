import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// iOS风格的底部导航栏
class IOSTabScaffold extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onIndexChanged;
  final List<BottomNavigationBarItem> items;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;

  const IOSTabScaffold({
    super.key,
    required this.currentIndex,
    this.onIndexChanged,
    required this.items,
    required this.children,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: onIndexChanged,
        items: items,
        backgroundColor: backgroundColor,
        activeColor: activeColor ?? CupertinoTheme.of(context).primaryColor,
        inactiveColor: inactiveColor ?? CupertinoColors.inactiveGray,
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => children[index],
        );
      },
    );
  }
}

// iOS风格的顶部标签栏
class IOSSegmentedTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onValueChanged;
  final List<String> tabs;
  final Color? backgroundColor;
  final Color? thumbColor;

  const IOSSegmentedTabBar({
    super.key,
    required this.currentIndex,
    this.onValueChanged,
    required this.tabs,
    this.backgroundColor,
    this.thumbColor,
  });

  @override
  Widget build(BuildContext context) {
    final children = <int, Widget>{};
    for (int i = 0; i < tabs.length; i++) {
      children[i] = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(tabs[i]),
      );
    }

    return CupertinoSlidingSegmentedControl<int>(
      groupValue: currentIndex,
      children: children,
      onValueChanged: (value) {
        if (value != null && onValueChanged != null) {
          onValueChanged!(value);
        }
      },
      backgroundColor: backgroundColor ?? CupertinoColors.tertiarySystemFill,
      thumbColor: thumbColor ?? CupertinoColors.white,
    );
  }
}

// iOS风格的返回按钮
class IOSBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final String? previousPageTitle;

  const IOSBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBarBackButton(
      onPressed: onPressed,
      color: color,
      previousPageTitle: previousPageTitle,
    );
  }
}

// iOS风格的侧边栏
class IOSSidebar extends StatelessWidget {
  final List<IOSSidebarItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final Widget? header;
  final Widget? footer;

  const IOSSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onItemSelected,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = index == selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      if (onItemSelected != null) {
                        onItemSelected!(index);
                      }
                    },
                    child: Container(
                      color: isSelected
                          ? CupertinoColors.systemGrey5
                          : CupertinoColors.systemGroupedBackground,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          if (item.icon != null) ...[
                            Icon(
                              item.icon,
                              color: isSelected
                                  ? CupertinoTheme.of(context).primaryColor
                                  : CupertinoColors.secondaryLabel,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 17,
                                color: isSelected
                                    ? CupertinoTheme.of(context).primaryColor
                                    : CupertinoColors.label,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (item.trailing != null) item.trailing!,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}

// iOS侧边栏项目
class IOSSidebarItem {
  final String title;
  final IconData? icon;
  final Widget? trailing;

  const IOSSidebarItem({
    required this.title,
    this.icon,
    this.trailing,
  });
}
