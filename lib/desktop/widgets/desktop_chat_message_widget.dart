import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../features/chat/widgets/chat_message_widget.dart';
import '../../core/models/chat_message.dart';
import '../../icons/lucide_adapter.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/snackbar.dart';
import 'desktop_popup_menu.dart';

/// Desktop-optimized chat message widget with right-click menu
/// 
/// Key differences from mobile:
/// - Right-click shows context menu instead of long-press
/// - Hover effect on user messages
/// - No touch-specific feedback
class DesktopChatMessageWidget extends StatelessWidget {
  const DesktopChatMessageWidget({
    super.key,
    required this.message,
    this.modelIcon,
    this.showModelIcon = true,
    this.useAssistantAvatar = false,
    this.assistantName,
    this.assistantAvatar,
    this.showUserAvatar = true,
    this.showTokenStats = true,
    this.onRegenerate,
    this.onResend,
    this.onCopy,
    this.onTranslate,
    this.onSpeak,
    this.onMore,
    this.onEdit,
    this.onDelete,
    this.versionIndex,
    this.versionCount,
    this.onPrevVersion,
    this.onNextVersion,
    this.reasoningText,
    this.reasoningExpanded = false,
    this.reasoningLoading = false,
    this.reasoningStartAt,
    this.reasoningFinishedAt,
    this.onToggleReasoning,
    this.reasoningSegments,
    this.translationExpanded = true,
    this.onToggleTranslation,
    this.toolParts,
  });

  final ChatMessage message;
  final Widget? modelIcon;
  final bool showModelIcon;
  final bool useAssistantAvatar;
  final String? assistantName;
  final String? assistantAvatar;
  final bool showUserAvatar;
  final bool showTokenStats;
  final VoidCallback? onRegenerate;
  final VoidCallback? onResend;
  final VoidCallback? onCopy;
  final VoidCallback? onTranslate;
  final VoidCallback? onSpeak;
  final VoidCallback? onMore;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final int? versionIndex;
  final int? versionCount;
  final VoidCallback? onPrevVersion;
  final VoidCallback? onNextVersion;
  final String? reasoningText;
  final bool reasoningExpanded;
  final bool reasoningLoading;
  final DateTime? reasoningStartAt;
  final DateTime? reasoningFinishedAt;
  final VoidCallback? onToggleReasoning;
  final List<ReasoningSegment>? reasoningSegments;
  final bool translationExpanded;
  final VoidCallback? onToggleTranslation;
  final List<ToolUIPart>? toolParts;

  @override
  Widget build(BuildContext context) {
    // For user messages, wrap with right-click detector
    if (message.role == 'user') {
      return GestureDetector(
        onSecondaryTapDown: (details) => _showContextMenu(context, details.globalPosition),
        child: _buildMessageWidget(),
      );
    }

    return _buildMessageWidget();
  }

  Widget _buildMessageWidget() {
    // Reuse the original ChatMessageWidget for actual rendering
    return ChatMessageWidget(
      message: message,
      modelIcon: modelIcon,
      showModelIcon: showModelIcon,
      useAssistantAvatar: useAssistantAvatar,
      assistantName: assistantName,
      assistantAvatar: assistantAvatar,
      showUserAvatar: showUserAvatar,
      showTokenStats: showTokenStats,
      onRegenerate: onRegenerate,
      onResend: onResend,
      onCopy: onCopy,
      onTranslate: onTranslate,
      onSpeak: onSpeak,
      onMore: onMore,
      onEdit: onEdit,
      onDelete: onDelete,
      versionIndex: versionIndex,
      versionCount: versionCount,
      onPrevVersion: onPrevVersion,
      onNextVersion: onNextVersion,
      reasoningText: reasoningText,
      reasoningExpanded: reasoningExpanded,
      reasoningLoading: reasoningLoading,
      reasoningStartAt: reasoningStartAt,
      reasoningFinishedAt: reasoningFinishedAt,
      onToggleReasoning: onToggleReasoning,
      reasoningSegments: reasoningSegments,
      translationExpanded: translationExpanded,
      onToggleTranslation: onToggleTranslation,
      toolParts: toolParts,
    );
  }

  void _showContextMenu(BuildContext context, Offset position) {
    final l10n = AppLocalizations.of(context)!;

    DesktopPopupMenu.show(
      context: context,
      position: position,
      items: [
        DesktopPopupMenuItem(
          icon: Lucide.Copy,
          label: l10n.shareProviderSheetCopyButton,
          onTap: () async {
            Navigator.of(context).pop();
            if (onCopy != null) {
              onCopy!.call();
            } else {
              await Clipboard.setData(ClipboardData(text: message.content));
              if (context.mounted) {
                showAppSnackBar(
                  context,
                  message: l10n.chatMessageWidgetCopiedToClipboard,
                  type: NotificationType.success,
                );
              }
            }
          },
        ),
        DesktopPopupMenuItem(
          icon: Lucide.Pencil,
          label: l10n.messageMoreSheetEdit,
          onTap: () {
            Navigator.of(context).pop();
            (onEdit ?? onMore)?.call();
          },
        ),
        DesktopPopupMenuItem(
          icon: Lucide.Trash2,
          label: l10n.messageMoreSheetDelete,
          danger: true,
          onTap: () {
            Navigator.of(context).pop();
            (onDelete ?? onMore)?.call();
          },
        ),
      ],
    );
  }
}
