import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/models/chat_message.dart';
import '../../../core/sizes.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/desktop_context_menu.dart';
import 'chat_message_widget.dart';

/// Desktop-specific chat message widget with right-click context menu
class DesktopChatMessageWidget extends StatefulWidget {
  final ChatMessage message;
  final VoidCallback? onCopy;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRegenerate;
  final VoidCallback? onBranch;
  final VoidCallback? onRetry;
  final VoidCallback? onSpeak;
  final VoidCallback? onTranslate;
  final bool isStreaming;
  final bool showAvatar;

  const DesktopChatMessageWidget({
    super.key,
    required this.message,
    this.onCopy,
    this.onEdit,
    this.onDelete,
    this.onRegenerate,
    this.onBranch,
    this.onRetry,
    this.onSpeak,
    this.onTranslate,
    this.isStreaming = false,
    this.showAvatar = true,
  });

  @override
  State<DesktopChatMessageWidget> createState() => _DesktopChatMessageWidgetState();
}

class _DesktopChatMessageWidgetState extends State<DesktopChatMessageWidget> {
  bool _isHovered = false;

  List<DesktopContextMenuItem> _buildContextMenuItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = <DesktopContextMenuItem>[];

    // Copy
    if (widget.message.content.isNotEmpty) {
      items.add(
        DesktopContextMenuItem(
          label: l10n.messageMoreSheetCopy,
          icon: Icons.copy_outlined,
          onTap: () {
            widget.onCopy?.call();
            Clipboard.setData(ClipboardData(text: widget.message.content));
          },
        ),
      );
    }

    // Edit (user messages only)
    if (widget.message.role == 'user' && widget.onEdit != null) {
      items.add(
        DesktopContextMenuItem(
          label: l10n.messageMoreSheetEdit,
          icon: Icons.edit_outlined,
          onTap: widget.onEdit,
        ),
      );
    }

    // Regenerate (assistant messages only)
    if (widget.message.role == 'assistant' && widget.onRegenerate != null && !widget.isStreaming) {
      items.add(
        DesktopContextMenuItem(
          label: l10n.messageMoreSheetRegenerate,
          icon: Icons.refresh,
          onTap: widget.onRegenerate,
        ),
      );
    }

    // Branch
    if (widget.onBranch != null) {
      items.add(
        DesktopContextMenuItem(
          label: l10n.messageMoreSheetBranch,
          icon: Icons.call_split,
          onTap: widget.onBranch,
        ),
      );
    }

    // Retry (failed messages)
    if (widget.onRetry != null) {
      items.add(
        DesktopContextMenuItem(
          label: l10n.messageMoreSheetRetry,
          icon: Icons.replay,
          onTap: widget.onRetry,
        ),
      );
    }

    // Speak
    if (widget.onSpeak != null && widget.message.content.isNotEmpty) {
      items.add(
        DesktopContextMenuItem(
          label: l10n.messageMoreSheetSpeak,
          icon: Icons.volume_up_outlined,
          onTap: widget.onSpeak,
        ),
      );
    }

    // Translate
    if (widget.onTranslate != null && widget.message.content.isNotEmpty) {
      items.add(
        DesktopContextMenuItem(
          label: l10n.messageMoreSheetTranslate,
          icon: Icons.translate,
          onTap: widget.onTranslate,
        ),
      );
    }

    if (items.isNotEmpty && widget.onDelete != null) {
      items.add(const DesktopContextMenuItem.divider());
    }

    // Delete
    if (widget.onDelete != null) {
      items.add(
        DesktopContextMenuItem(
          label: l10n.messageMoreSheetDelete,
          icon: Icons.delete_outline,
          onTap: widget.onDelete,
          isDestructive: true,
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUser = widget.message.role == 'user';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: DesktopContextMenuRegion(
        items: _buildContextMenuItems(context),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ChatSizes.messageHorizontalPadding,
            vertical: ChatSizes.messageVerticalPadding,
          ),
          decoration: _isHovered
              ? BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                )
              : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              if (widget.showAvatar) ...[
                _buildAvatar(context),
                SizedBox(width: AppSizes.lg),
              ],
              
              // Message content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message header with actions
                    Row(
                      children: [
                        Text(
                          isUser ? 'You' : 'Assistant',
                          style: TextStyle(
                            fontSize: AppSizes.fontSize13,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        if (_isHovered && !widget.isStreaming)
                          _buildQuickActions(context),
                      ],
                    ),
                    SizedBox(height: AppSizes.sm),
                    
                    // Message content
                    SelectableText(
                      widget.message.content,
                      style: TextStyle(
                        fontSize: AppSizes.fontSize14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    
                    // Streaming indicator
                    if (widget.isStreaming) ...[
                      SizedBox(height: AppSizes.sm),
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUser = widget.message.role == 'user';

    return Container(
      width: ChatSizes.avatarSize,
      height: ChatSizes.avatarSize,
      decoration: BoxDecoration(
        color: isUser
            ? colorScheme.primaryContainer
            : colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(ChatSizes.avatarRadius),
      ),
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        size: 18,
        color: isUser
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSecondaryContainer,
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Copy button
        if (widget.message.content.isNotEmpty)
          IconButton(
            icon: Icon(Icons.copy_outlined, size: 16),
            iconSize: 16,
            padding: EdgeInsets.all(AppSizes.sm),
            constraints: const BoxConstraints(
              minWidth: 28,
              minHeight: 28,
            ),
            tooltip: 'Copy',
            onPressed: () {
              widget.onCopy?.call();
              Clipboard.setData(ClipboardData(text: widget.message.content));
            },
          ),
        
        // More options button
        IconButton(
          icon: Icon(Icons.more_horiz, size: 16),
          iconSize: 16,
          padding: EdgeInsets.all(AppSizes.sm),
          constraints: const BoxConstraints(
            minWidth: 28,
            minHeight: 28,
          ),
          tooltip: 'More options',
          onPressed: () {
            // Show context menu on button click
            final RenderBox button = context.findRenderObject() as RenderBox;
            final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(Offset.zero, ancestor: overlay),
                button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            );
            
            showMenu(
              context: context,
              position: position,
              items: _buildContextMenuItems(context)
                  .where((item) => !item.isDivider)
                  .map((item) {
                return PopupMenuItem(
                  onTap: item.onTap,
                  child: Row(
                    children: [
                      if (item.icon != null) ...[
                        Icon(item.icon, size: 18),
                        SizedBox(width: AppSizes.lg),
                      ],
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
