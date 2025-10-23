import 'dart:io';
import 'package:flutter/foundation.dart';

/// Platform detection helper for cross-platform adaptation
class PlatformHelper {
  /// Check if running on mobile platform (Android/iOS)
  static bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Check if running on desktop platform (Windows/macOS/Linux)
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Check if running on iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Check if running on Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Check if running on macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Check if running on Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Check if running on desktop or web
  static bool get isDesktopOrWeb {
    if (kIsWeb) return true;
    return isDesktop;
  }

  /// Check if not on mobile
  static bool get isNotMobile => !isMobile;
}
