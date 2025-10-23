import 'package:flutter/widgets.dart';
import '../../core/platform_extension.dart';

/// Platform-specific widget builder following AppFlowy's architecture
/// Allows rendering different widgets based on the current platform
class PlatformWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const PlatformWidget({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformExtension.isDesktop) {
      return desktop;
    } else if (PlatformExtension.isMobile) {
      return tablet ?? mobile;
    } else {
      // Web or other platforms - default to desktop
      return desktop;
    }
  }
}

/// Responsive widget builder based on screen width
/// Uses MediaQuery to determine the appropriate widget to display
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final double? mobileBreakpoint;
  final double? desktopBreakpoint;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.mobileBreakpoint,
    this.desktopBreakpoint,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final mobileBreak = mobileBreakpoint ?? 600;
        final desktopBreak = desktopBreakpoint ?? 1200;

        if (width < mobileBreak) {
          return mobile;
        } else if (width < desktopBreak) {
          return tablet ?? mobile;
        } else {
          return desktop;
        }
      },
    );
  }
}

/// Builder for platform-specific values
class PlatformValue<T> {
  final T mobile;
  final T? tablet;
  final T desktop;

  const PlatformValue({
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  T get value {
    if (PlatformExtension.isDesktop) {
      return desktop;
    } else if (PlatformExtension.isMobile) {
      return tablet ?? mobile;
    } else {
      return desktop;
    }
  }

  static T getValue<T>({
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (PlatformExtension.isDesktop) {
      return desktop;
    } else if (PlatformExtension.isMobile) {
      return tablet ?? mobile;
    } else {
      return desktop;
    }
  }
}
