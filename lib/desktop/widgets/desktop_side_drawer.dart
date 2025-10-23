import 'package:flutter/material.dart';
import '../../features/home/widgets/side_drawer.dart';
import '../../core/platform_helper.dart';

/// Desktop-optimized sidebar that replaces bottom sheets with popup menus
/// and long-press with right-click context menus
/// 
/// For the initial implementation, we reuse the existing SideDrawer
/// which works well on desktop when embedded=true.
/// 
/// Future enhancements:
/// - Replace conversation long-press with right-click menu
/// - Add hover effects on conversation items
/// - Replace avatar tap bottom sheet with popup menu
/// - Add keyboard shortcuts for navigation
class DesktopSideDrawer extends StatelessWidget {
  const DesktopSideDrawer({
    super.key,
    required this.userName,
    required this.assistantName,
    this.onSelectConversation,
    this.onNewConversation,
    this.closePickerTicker,
    this.loadingConversationIds = const <String>{},
    this.embeddedWidth,
  });

  final String userName;
  final String assistantName;
  final void Function(String id)? onSelectConversation;
  final VoidCallback? onNewConversation;
  final ValueNotifier<int>? closePickerTicker;
  final Set<String> loadingConversationIds;
  final double? embeddedWidth;

  @override
  Widget build(BuildContext context) {
    // For now, reuse the existing SideDrawer with embedded mode
    // In the future, create a fully custom desktop sidebar here
    return SideDrawer(
      embedded: true,
      embeddedWidth: embeddedWidth,
      userName: userName,
      assistantName: assistantName,
      onSelectConversation: onSelectConversation,
      onNewConversation: onNewConversation,
      closePickerTicker: closePickerTicker,
      loadingConversationIds: loadingConversationIds,
    );
  }
}
