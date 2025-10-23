import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base_appearance.dart';
import '../../core/sizes.dart';

/// Desktop-specific theme implementation following AppFlowy's architecture
class DesktopAppearance extends BaseAppearance {
  @override
  ThemeData getThemeData(
    Brightness brightness,
    ColorScheme colorScheme, {
    ColorScheme? dynamicScheme,
  }) {
    final scheme = dynamicScheme ?? colorScheme;
    final isLight = brightness == Brightness.light;

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
    );

    return baseTheme.copyWith(
      // Desktop-specific text theme (smaller font sizes)
      textTheme: _buildDesktopTextTheme(baseTheme.textTheme, scheme),
      
      // Desktop scrollbar theme
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered) ||
              states.contains(MaterialState.pressed)) {
            return scheme.onSurface.withOpacity(0.4);
          }
          return scheme.onSurface.withOpacity(0.2);
        }),
        thickness: MaterialStateProperty.all(6.0),
        radius: const Radius.circular(AppSizes.radiusMd),
        crossAxisMargin: 2.0,
        mainAxisMargin: 4.0,
      ),

      // Desktop tooltip theme
      tooltipTheme: TooltipThemeData(
        textStyle: getTextStyle(
          fontSize: AppSizes.fontSize12,
          color: scheme.onInverseSurface,
        ),
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
        waitDuration: const Duration(milliseconds: 500),
      ),

      // Desktop app bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: HomeSizes.desktopTopBarHeight,
        titleTextStyle: getTextStyle(
          fontSize: AppSizes.fontSize16,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: scheme.onSurface,
          size: 20,
        ),
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),

      // Desktop button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            Size(120, HomeSizes.buttonHeight),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: AppSizes.xxl),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            Size(80, HomeSizes.buttonHeight),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: AppSizes.xl),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            Size(120, HomeSizes.buttonHeight),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: AppSizes.xxl),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        ),
      ),

      // Desktop input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceVariant.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: scheme.outlineVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: scheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: scheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: scheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: scheme.error,
            width: 2,
          ),
        ),
      ),

      // Desktop card theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          side: BorderSide(
            color: scheme.outlineVariant.withOpacity(0.3),
          ),
        ),
        margin: const EdgeInsets.all(AppSizes.md),
      ),

      // Desktop dialog theme
      dialogTheme: DialogTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        titleTextStyle: getTextStyle(
          fontSize: AppSizes.fontSize18,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        contentTextStyle: getTextStyle(
          fontSize: AppSizes.fontSize14,
          color: scheme.onSurface,
        ),
      ),

      // Desktop snackbar theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: getTextStyle(
          fontSize: AppSizes.fontSize14,
          fontWeight: FontWeight.w500,
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        actionTextColor: scheme.primary,
      ),
    );
  }

  TextTheme _buildDesktopTextTheme(TextTheme base, ColorScheme scheme) {
    return base.copyWith(
      displayLarge: getTextStyle(
        fontSize: AppSizes.fontSize32,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      displayMedium: getTextStyle(
        fontSize: AppSizes.fontSize28,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      displaySmall: getTextStyle(
        fontSize: AppSizes.fontSize24,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      headlineLarge: getTextStyle(
        fontSize: AppSizes.fontSize24,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      headlineMedium: getTextStyle(
        fontSize: AppSizes.fontSize20,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      headlineSmall: getTextStyle(
        fontSize: AppSizes.fontSize18,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleLarge: getTextStyle(
        fontSize: AppSizes.fontSize16,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleMedium: getTextStyle(
        fontSize: AppSizes.fontSize14,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleSmall: getTextStyle(
        fontSize: AppSizes.fontSize13,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      bodyLarge: getTextStyle(
        fontSize: AppSizes.fontSize14,
        color: scheme.onSurface,
      ),
      bodyMedium: getTextStyle(
        fontSize: AppSizes.fontSize13,
        color: scheme.onSurface,
      ),
      bodySmall: getTextStyle(
        fontSize: AppSizes.fontSize12,
        color: scheme.onSurface,
      ),
      labelLarge: getTextStyle(
        fontSize: AppSizes.fontSize14,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
      labelMedium: getTextStyle(
        fontSize: AppSizes.fontSize12,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
      labelSmall: getTextStyle(
        fontSize: AppSizes.fontSize11,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
    );
  }
}
