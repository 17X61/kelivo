import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/sizes.dart';
import '../../../core/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/desktop_context_menu.dart';

/// Desktop-specific settings page with sidebar navigation
class DesktopSettingsPage extends StatefulWidget {
  const DesktopSettingsPage({super.key});

  @override
  State<DesktopSettingsPage> createState() => _DesktopSettingsPageState();
}

class _DesktopSettingsPageState extends State<DesktopSettingsPage> {
  int _selectedIndex = 0;

  final List<_SettingsSection> _sections = [
    _SettingsSection(
      icon: Icons.palette_outlined,
      label: 'Appearance',
    ),
    _SettingsSection(
      icon: Icons.language_outlined,
      label: 'Language',
    ),
    _SettingsSection(
      icon: Icons.smart_toy_outlined,
      label: 'Models',
    ),
    _SettingsSection(
      icon: Icons.person_outline,
      label: 'Assistants',
    ),
    _SettingsSection(
      icon: Icons.search_outlined,
      label: 'Search',
    ),
    _SettingsSection(
      icon: Icons.extension_outlined,
      label: 'MCP Tools',
    ),
    _SettingsSection(
      icon: Icons.cloud_outlined,
      label: 'Providers',
    ),
    _SettingsSection(
      icon: Icons.backup_outlined,
      label: 'Backup',
    ),
    _SettingsSection(
      icon: Icons.info_outline,
      label: 'About',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Row(
        children: [
          // Sidebar navigation
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.all(AppSizes.md),
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                final section = _sections[index];
                final isSelected = index == _selectedIndex;

                return Container(
                  margin: EdgeInsets.only(bottom: AppSizes.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      section.icon,
                      size: 20,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                    ),
                    title: Text(
                      section.label,
                      style: TextStyle(
                        fontSize: AppSizes.fontSize14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Content area
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: HomeSizes.maxContentWidth,
              ),
              padding: EdgeInsets.all(AppSizes.xxl),
              child: _buildContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _buildAppearanceSettings(context);
      case 1:
        return _buildLanguageSettings(context);
      case 2:
        return _buildModelsSettings(context);
      case 3:
        return _buildAssistantsSettings(context);
      case 4:
        return _buildSearchSettings(context);
      case 5:
        return _buildMcpSettings(context);
      case 6:
        return _buildProvidersSettings(context);
      case 7:
        return _buildBackupSettings(context);
      case 8:
        return _buildAboutSettings(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAppearanceSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      children: [
        Text(
          'Appearance',
          style: TextStyle(
            fontSize: AppSizes.fontSize24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSizes.xxl),

        // Theme mode
        _SettingRow(
          label: l10n.settingsPageColorMode,
          child: DesktopDropdownMenuButton<ThemeMode>(
            value: settings.themeMode,
            width: 200,
            items: [
              DesktopDropdownMenuItem(
                value: ThemeMode.system,
                label: l10n.settingsPageSystemMode,
                icon: Icons.brightness_auto,
              ),
              DesktopDropdownMenuItem(
                value: ThemeMode.light,
                label: l10n.settingsPageLightMode,
                icon: Icons.light_mode,
              ),
              DesktopDropdownMenuItem(
                value: ThemeMode.dark,
                label: l10n.settingsPageDarkMode,
                icon: Icons.dark_mode,
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                settings.setThemeMode(value);
              }
            },
          ),
        ),

        SizedBox(height: AppSizes.lg),

        // Dynamic color (Android only)
        if (settings.dynamicColorSupported)
          _SettingRow(
            label: l10n.settingsPageDynamicColor,
            child: Switch(
              value: settings.useDynamicColor,
              onChanged: (value) {
                settings.setUseDynamicColor(value);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildLanguageSettings(BuildContext context) {
    return Center(
      child: Text('Language settings coming soon'),
    );
  }

  Widget _buildModelsSettings(BuildContext context) {
    return Center(
      child: Text('Models settings coming soon'),
    );
  }

  Widget _buildAssistantsSettings(BuildContext context) {
    return Center(
      child: Text('Assistants settings coming soon'),
    );
  }

  Widget _buildSearchSettings(BuildContext context) {
    return Center(
      child: Text('Search settings coming soon'),
    );
  }

  Widget _buildMcpSettings(BuildContext context) {
    return Center(
      child: Text('MCP settings coming soon'),
    );
  }

  Widget _buildProvidersSettings(BuildContext context) {
    return Center(
      child: Text('Providers settings coming soon'),
    );
  }

  Widget _buildBackupSettings(BuildContext context) {
    return Center(
      child: Text('Backup settings coming soon'),
    );
  }

  Widget _buildAboutSettings(BuildContext context) {
    return Center(
      child: Text('About settings coming soon'),
    );
  }
}

class _SettingsSection {
  final IconData icon;
  final String label;

  _SettingsSection({
    required this.icon,
    required this.label,
  });
}

class _SettingRow extends StatelessWidget {
  final String label;
  final Widget child;
  final String? description;

  const _SettingRow({
    required this.label,
    required this.child,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSizes.fontSize16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (description != null) ...[
                  SizedBox(height: AppSizes.xs),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: AppSizes.fontSize13,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppSizes.xxl),
          child,
        ],
      ),
    );
  }
}
