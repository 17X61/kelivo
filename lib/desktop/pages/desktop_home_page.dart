import 'package:flutter/material.dart';
import '../../features/home/pages/home_page.dart';
import '../../core/platform_helper.dart';

/// Desktop home page - wrapper that ensures desktop-specific layout
/// 
/// For desktop platforms, this uses the tablet layout from HomePage which provides:
/// - Fixed sidebar instead of drawer
/// - Wider layout constraints
/// - Desktop-optimized spacing
/// 
/// The actual implementation reuses HomePage's tablet layout (_buildTabletLayout)
/// since it already provides a good desktop experience with:
/// - Embedded sidebar with toggle
/// - Constrained content area (maxWidth: 860)
/// - Desktop-appropriate app bar
class DesktopHomePage extends StatelessWidget {
  const DesktopHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, we reuse the existing HomePage which already has tablet/desktop
    // layout built in. The HomePage automatically switches to tablet layout
    // when width >= AppBreakpoints.tablet (900px), which is perfect for desktop.
    // 
    // In the future, we can create fully custom desktop layouts here with:
    // - Right-click context menus instead of bottom sheets
    // - Hover effects on buttons and interactive elements  
    // - Popup menus instead of modal sheets
    // - Keyboard shortcuts
    // - Multi-window support
    return const HomePage();
  }
}
