import 'platform_extension.dart';

/// Dynamic spacing system based on AppFlowy's architecture
class AppSizes {
  static double scale = 1.0;

  // Spacing constants
  static double get xs => 2 * scale;
  static double get sm => 4 * scale;
  static double get md => 8 * scale;
  static double get lg => 12 * scale;
  static double get xl => 16 * scale;
  static double get xxl => 24 * scale;
  static double get xxxl => 32 * scale;
  static double get huge => 48 * scale;

  // Font sizes
  static double get fontSize10 => 10 * scale;
  static double get fontSize11 => 11 * scale;
  static double get fontSize12 => 12 * scale;
  static double get fontSize13 => 13 * scale;
  static double get fontSize14 => 14 * scale;
  static double get fontSize16 => 16 * scale;
  static double get fontSize18 => 18 * scale;
  static double get fontSize20 => 20 * scale;
  static double get fontSize24 => 24 * scale;
  static double get fontSize28 => 28 * scale;
  static double get fontSize32 => 32 * scale;

  // Border radius
  static const double radiusXs = 2;
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusXxl = 24;
  static const double radiusRound = 999;
}

/// Home page sizes based on platform
class HomeSizes {
  static double get scale => 1.0;

  // Desktop-specific sizes
  static double get desktopMenuWidth => 268 * scale;
  static double get desktopMinimumSidebarWidth => 268 * scale;
  static double get desktopTopBarHeight => 44 * scale;
  static double get desktopEditPanelWidth => 400 * scale;
  static double get desktopDrawerWidth => 320 * scale;

  // Mobile-specific sizes
  static double get mobileTopBarHeight => 56 * scale;
  static double get mobileDrawerWidth => 280 * scale;
  static double get mobileBottomBarHeight => 56 * scale;
  static double get mobileButtonHeight => 48 * scale;
  static double get mobileTouchTarget => 44 * scale;

  // Platform-adaptive sizes
  static double get topBarHeight =>
      PlatformExtension.isDesktop ? desktopTopBarHeight : mobileTopBarHeight;

  static double get drawerWidth =>
      PlatformExtension.isDesktop ? desktopDrawerWidth : mobileDrawerWidth;

  static double get buttonHeight =>
      PlatformExtension.isDesktop ? 36 * scale : mobileButtonHeight;

  static double get touchTarget =>
      PlatformExtension.isDesktop ? 32 * scale : mobileTouchTarget;

  // Padding
  static double get horizontalPadding =>
      PlatformExtension.isDesktop ? 16 * scale : 20 * scale;

  static double get verticalPadding =>
      PlatformExtension.isDesktop ? 8 * scale : 12 * scale;

  // Content widths
  static double get maxContentWidth => 1200 * scale;
  static double get maxDialogWidth => 600 * scale;
}

/// Chat-specific sizes
class ChatSizes {
  static double get scale => 1.0;

  // Message spacing
  static double get messageSpacing =>
      PlatformExtension.isDesktop ? 12 * scale : 16 * scale;

  static double get messageHorizontalPadding =>
      PlatformExtension.isDesktop ? 16 * scale : 20 * scale;

  static double get messageVerticalPadding =>
      PlatformExtension.isDesktop ? 12 * scale : 16 * scale;

  // Input bar
  static double get inputBarMinHeight =>
      PlatformExtension.isDesktop ? 56 * scale : 72 * scale;

  static double get inputBarMaxHeight =>
      PlatformExtension.isDesktop ? 200 * scale : 240 * scale;

  static double get inputBarPadding =>
      PlatformExtension.isDesktop ? 12 * scale : 16 * scale;

  // Avatar sizes
  static double get avatarSize =>
      PlatformExtension.isDesktop ? 32 * scale : 36 * scale;

  static double get avatarRadius =>
      PlatformExtension.isDesktop ? 8 * scale : 10 * scale;
}

/// Settings page sizes
class SettingsSizes {
  static double get scale => 1.0;

  static double get itemHeight =>
      PlatformExtension.isDesktop ? 48 * scale : 56 * scale;

  static double get sectionSpacing =>
      PlatformExtension.isDesktop ? 24 * scale : 32 * scale;

  static double get horizontalPadding =>
      PlatformExtension.isDesktop ? 24 * scale : 20 * scale;
}
