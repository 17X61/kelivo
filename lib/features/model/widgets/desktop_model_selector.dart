import 'package:flutter/material.dart';
import '../../../core/sizes.dart';
import '../../../core/providers/settings_provider.dart';

/// Desktop model selector using dropdown menu
class DesktopModelSelector extends StatelessWidget {
  final String? selectedProvider;
  final String? selectedModel;
  final ValueChanged<(String, String)>? onSelect;
  final VoidCallback? onManageModels;

  const DesktopModelSelector({
    super.key,
    this.selectedProvider,
    this.selectedModel,
    this.onSelect,
    this.onManageModels,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<(String, String)>(
      tooltip: 'Select Model',
      onSelected: onSelect,
      itemBuilder: (context) {
        final items = <PopupMenuEntry<(String, String)>>[];

        // Group models by provider
        final providers = _getProviders();
        
        for (int i = 0; i < providers.length; i++) {
          final provider = providers[i];
          
          if (i > 0) {
            items.add(const PopupMenuDivider());
          }
          
          // Provider header
          items.add(
            PopupMenuItem<(String, String)>(
              enabled: false,
              child: Text(
                provider.name,
                style: TextStyle(
                  fontSize: AppSizes.fontSize12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          );
          
          // Models for this provider
          for (final model in provider.models) {
            final isSelected = selectedProvider == provider.id &&
                selectedModel == model.id;
            
            items.add(
              PopupMenuItem<(String, String)>(
                value: (provider.id, model.id),
                child: Row(
                  children: [
                    SizedBox(width: AppSizes.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            model.name,
                            style: TextStyle(
                              fontSize: AppSizes.fontSize14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (model.description != null)
                            Text(
                              model.description!,
                              style: TextStyle(
                                fontSize: AppSizes.fontSize12,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                  ],
                ),
              ),
            );
          }
        }

        // Manage models button
        if (onManageModels != null) {
          items.add(const PopupMenuDivider());
          items.add(
            PopupMenuItem<(String, String)>(
              onTap: onManageModels,
              child: Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: AppSizes.lg),
                  Text(
                    'Manage Models',
                    style: TextStyle(
                      fontSize: AppSizes.fontSize14,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return items;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.smart_toy_outlined,
              size: 18,
              color: colorScheme.onSurface,
            ),
            SizedBox(width: AppSizes.md),
            Text(
              _getDisplayName(),
              style: TextStyle(
                fontSize: AppSizes.fontSize14,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(width: AppSizes.md),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayName() {
    if (selectedModel == null) return 'Select Model';
    
    final providers = _getProviders();
    for (final provider in providers) {
      for (final model in provider.models) {
        if (model.id == selectedModel) {
          return model.name;
        }
      }
    }
    
    return selectedModel!;
  }

  List<_ModelProvider> _getProviders() {
    // TODO: Get actual providers from settings
    return [
      _ModelProvider(
        id: 'openai',
        name: 'OpenAI',
        models: [
          _ModelInfo(
            id: 'gpt-4-turbo',
            name: 'GPT-4 Turbo',
            description: 'Most capable model',
          ),
          _ModelInfo(
            id: 'gpt-4',
            name: 'GPT-4',
            description: 'Standard GPT-4',
          ),
          _ModelInfo(
            id: 'gpt-3.5-turbo',
            name: 'GPT-3.5 Turbo',
            description: 'Fast and efficient',
          ),
        ],
      ),
      _ModelProvider(
        id: 'anthropic',
        name: 'Anthropic',
        models: [
          _ModelInfo(
            id: 'claude-3-opus',
            name: 'Claude 3 Opus',
            description: 'Most capable Claude model',
          ),
          _ModelInfo(
            id: 'claude-3-sonnet',
            name: 'Claude 3 Sonnet',
            description: 'Balanced performance',
          ),
        ],
      ),
      _ModelProvider(
        id: 'google',
        name: 'Google',
        models: [
          _ModelInfo(
            id: 'gemini-pro',
            name: 'Gemini Pro',
            description: 'Google\'s advanced model',
          ),
        ],
      ),
    ];
  }
}

class _ModelProvider {
  final String id;
  final String name;
  final List<_ModelInfo> models;

  _ModelProvider({
    required this.id,
    required this.name,
    required this.models,
  });
}

class _ModelInfo {
  final String id;
  final String name;
  final String? description;

  _ModelInfo({
    required this.id,
    required this.name,
    this.description,
  });
}
