import 'package:flutter/material.dart';
import '../../../core/models/assistant.dart';
import '../../../core/sizes.dart';
import '../../../shared/widgets/desktop_context_menu.dart';

/// Desktop assistant selector using dropdown menu
class DesktopAssistantSelector extends StatelessWidget {
  final List<Assistant> assistants;
  final Assistant? selectedAssistant;
  final ValueChanged<Assistant>? onSelect;
  final VoidCallback? onManageAssistants;

  const DesktopAssistantSelector({
    super.key,
    required this.assistants,
    this.selectedAssistant,
    this.onSelect,
    this.onManageAssistants,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<Assistant>(
      tooltip: 'Select Assistant',
      initialValue: selectedAssistant,
      onSelected: onSelect,
      itemBuilder: (context) {
        final items = <PopupMenuEntry<Assistant>>[];

        // Assistant items
        for (final assistant in assistants) {
          items.add(
            PopupMenuItem<Assistant>(
              value: assistant,
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: assistant.avatar != null && assistant.avatar!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              assistant.avatar!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.smart_toy,
                                size: 16,
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.smart_toy,
                            size: 16,
                            color: colorScheme.onSecondaryContainer,
                          ),
                  ),
                  SizedBox(width: AppSizes.lg),
                  
                  // Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          assistant.name,
                          style: TextStyle(
                            fontSize: AppSizes.fontSize14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (assistant.systemPrompt != null &&
                            assistant.systemPrompt!.isNotEmpty)
                          Text(
                            assistant.systemPrompt!,
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
                  
                  // Selected indicator
                  if (selectedAssistant?.id == assistant.id)
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

        // Divider and manage button
        if (onManageAssistants != null) {
          items.add(const PopupMenuDivider());
          items.add(
            PopupMenuItem<Assistant>(
              onTap: onManageAssistants,
              child: Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: AppSizes.lg),
                  Text(
                    'Manage Assistants',
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
              Icons.person_outline,
              size: 18,
              color: colorScheme.onSurface,
            ),
            SizedBox(width: AppSizes.md),
            Text(
              selectedAssistant?.name ?? 'Select Assistant',
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
}
