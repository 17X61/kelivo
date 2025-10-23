import 'dart:io';
import 'package:flutter/foundation.dart';

/// Platform detection utilities following AppFlowy's architecture
class PlatformExtension {
  /// macOS platform detection (excluding Web)
  static bool get isMacOS {
    if (kIsWeb) return false;
    return Platform.isMacOS;
  }

  /// Windows platform detection
  static bool get isWindows {
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  /// Linux platform detection
  static bool get isLinux {
    if (kIsWeb) return false;
    return Platform.isLinux;
  }

  /// Desktop platform or Web detection
  static bool get isDesktopOrWeb {
    if (kIsWeb) return true;
    return isDesktop;
  }

  /// Desktop platform detection (Windows/Linux/macOS)
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  /// Mobile platform detection (Android/iOS)
  static bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Android platform detection
  static bool get isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  /// iOS platform detection
  static bool get isIOS {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  /// Non-mobile platform detection
  static bool get isNotMobile {
    if (kIsWeb) return false;
    return !isMobile;
  }

  /// Web platform detection
  static bool get isWeb => kIsWeb;
}
