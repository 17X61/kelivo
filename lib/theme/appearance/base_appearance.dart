import 'package:flutter/material.dart';
import '../../core/platform_extension.dart';
import '../../core/sizes.dart';

/// Base appearance class following AppFlowy's architecture
/// Provides common theme building functionality for different platforms
abstract class BaseAppearance {
  /// Build theme data for the specific platform
  ThemeData getThemeData(
    Brightness brightness,
    ColorScheme colorScheme, {
    ColorScheme? dynamicScheme,
  });

  /// Get text style with proper font fallback
  TextStyle getTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    List<String>? fontFamilyFallback,
  }) {
    return TextStyle(
      fontSize: fontSize ?? AppSizes.fontSize14,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontFamilyFallback: fontFamilyFallback ?? _defaultFontFallback,
    );
  }

  /// Default font fallback list for CJK support
  static const List<String> _defaultFontFallback = [
    'PingFang SC',
    'Heiti SC',
    'Hiragino Sans GB',
    'Roboto',
  ];

  /// Apply font fallback to entire text theme
  TextTheme applyFontFallback(TextTheme textTheme, List<String> fallback) {
    TextStyle? applyToStyle(TextStyle? style) {
      if (style == null) return null;
      return style.copyWith(fontFamilyFallback: fallback);
    }

    return textTheme.copyWith(
      displayLarge: applyToStyle(textTheme.displayLarge),
      displayMedium: applyToStyle(textTheme.displayMedium),
      displaySmall: applyToStyle(textTheme.displaySmall),
      headlineLarge: applyToStyle(textTheme.headlineLarge),
      headlineMedium: applyToStyle(textTheme.headlineMedium),
      headlineSmall: applyToStyle(textTheme.headlineSmall),
      titleLarge: applyToStyle(textTheme.titleLarge),
      titleMedium: applyToStyle(textTheme.titleMedium),
      titleSmall: applyToStyle(textTheme.titleSmall),
      bodyLarge: applyToStyle(textTheme.bodyLarge),
      bodyMedium: applyToStyle(textTheme.bodyMedium),
      bodySmall: applyToStyle(textTheme.bodySmall),
      labelLarge: applyToStyle(textTheme.labelLarge),
      labelMedium: applyToStyle(textTheme.labelMedium),
      labelSmall: applyToStyle(textTheme.labelSmall),
    );
  }

  /// Get platform-appropriate button height
  double getButtonHeight() {
    return PlatformExtension.isDesktop ? 36.0 : 48.0;
  }

  /// Get platform-appropriate padding
  EdgeInsets getStandardPadding() {
    return EdgeInsets.symmetric(
      horizontal: HomeSizes.horizontalPadding,
      vertical: HomeSizes.verticalPadding,
    );
  }

  /// Get platform-appropriate border radius
  BorderRadius getStandardBorderRadius() {
    return BorderRadius.circular(
      PlatformExtension.isDesktop ? AppSizes.radiusMd : AppSizes.radiusLg,
    );
  }
}
