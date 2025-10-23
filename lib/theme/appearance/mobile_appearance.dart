import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base_appearance.dart';
import '../../core/sizes.dart';

/// Mobile-specific theme implementation following AppFlowy's architecture
class MobileAppearance extends BaseAppearance {
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
      // Mobile-specific text theme (larger font sizes)
      textTheme: _buildMobileTextTheme(baseTheme.textTheme, scheme),
      
      // Mobile scrollbar theme (thicker for touch)
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(
          scheme.onSurface.withOpacity(0.3),
        ),
        thickness: MaterialStateProperty.all(8.0),
        radius: const Radius.circular(AppSizes.radiusLg),
      ),

      // Mobile tooltip theme (larger for touch)
      tooltipTheme: TooltipThemeData(
        textStyle: getTextStyle(
          fontSize: AppSizes.fontSize14,
          color: scheme.onInverseSurface,
        ),
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xl,
          vertical: AppSizes.lg,
        ),
      ),

      // Mobile app bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: HomeSizes.mobileTopBarHeight,
        titleTextStyle: getTextStyle(
          fontSize: AppSizes.fontSize18,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: scheme.onSurface,
          size: 24,
        ),
        systemOverlayStyle: isLight
            ? const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarIconBrightness: Brightness.dark,
              )
            : const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
      ),

      // Mobile button themes (larger touch targets)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            Size(double.infinity, HomeSizes.mobileButtonHeight),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: AppSizes.xxl),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            Size(80, HomeSizes.mobileButtonHeight),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: AppSizes.xl),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            Size(double.infinity, HomeSizes.mobileButtonHeight),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: AppSizes.xxl),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
          ),
        ),
      ),

      // Mobile input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceVariant.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xl,
          vertical: AppSizes.xl,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: BorderSide(
            color: scheme.outlineVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: BorderSide(
            color: scheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: BorderSide(
            color: scheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: BorderSide(
            color: scheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: BorderSide(
            color: scheme.error,
            width: 2,
          ),
        ),
      ),

      // Mobile card theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          side: BorderSide(
            color: scheme.outlineVariant.withOpacity(0.3),
          ),
        ),
        margin: const EdgeInsets.all(AppSizes.lg),
      ),

      // Mobile dialog theme (often shown as bottom sheets)
      dialogTheme: DialogTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        titleTextStyle: getTextStyle(
          fontSize: AppSizes.fontSize20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        contentTextStyle: getTextStyle(
          fontSize: AppSizes.fontSize16,
          color: scheme.onSurface,
        ),
      ),

      // Mobile snackbar theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: getTextStyle(
          fontSize: AppSizes.fontSize16,
          fontWeight: FontWeight.w500,
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        actionTextColor: scheme.primary,
      ),

      // Mobile bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: getTextStyle(
          fontSize: AppSizes.fontSize12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: getTextStyle(
          fontSize: AppSizes.fontSize12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  TextTheme _buildMobileTextTheme(TextTheme base, ColorScheme scheme) {
    return base.copyWith(
      displayLarge: getTextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      displayMedium: getTextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      displaySmall: getTextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      headlineLarge: getTextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      headlineMedium: getTextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      headlineSmall: getTextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleLarge: getTextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleMedium: getTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleSmall: getTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      bodyLarge: getTextStyle(
        fontSize: 16,
        color: scheme.onSurface,
      ),
      bodyMedium: getTextStyle(
        fontSize: 14,
        color: scheme.onSurface,
      ),
      bodySmall: getTextStyle(
        fontSize: 12,
        color: scheme.onSurface,
      ),
      labelLarge: getTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
      labelMedium: getTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
      labelSmall: getTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
    );
  }
}
