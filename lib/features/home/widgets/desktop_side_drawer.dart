import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/sizes.dart';
import '../../../core/models/conversation.dart';
import '../../../shared/widgets/desktop_context_menu.dart';
import 'package:provider/provider.dart';
import '../../../core/services/chat/chat_service.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/assistant_provider.dart';

/// Desktop-specific side drawer with right-click context menus
class DesktopSideDrawer extends StatefulWidget {
  final double width;
  final VoidCallback? onNewConversation;
  final Function(String)? onSelectConversation;

  const DesktopSideDrawer({
    super.key,
    this.width = 280,
    this.onNewConversation,
    this.onSelectConversation,
  });

  @override
  State<DesktopSideDrawer> createState() => _DesktopSideDrawerState();
}

class _DesktopSideDrawerState extends State<DesktopSideDrawer> {
  String _hoveredConversationId = '';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DesktopContextMenuItem> _buildConversationContextMenu(
    BuildContext context,
    Conversation conversation,
  ) {
    final chatService = context.read<ChatService>();

    return [
      DesktopContextMenuItem(
        label: conversation.isPinned ? 'Unpin' : 'Pin',
        icon: conversation.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
        onTap: () async {
          // TODO: Implement pin toggle
          // await chatService.togglePin(conversation.id);
        },
      ),
      DesktopContextMenuItem(
        label: 'Rename',
        icon: Icons.edit_outlined,
        onTap: () {
          _showRenameDialog(context, conversation);
        },
      ),
      const DesktopContextMenuItem.divider(),
      DesktopContextMenuItem(
        label: 'Export',
        icon: Icons.download_outlined,
        onTap: () {
          // TODO: Export conversation
        },
      ),
      DesktopContextMenuItem(
        label: 'Share',
        icon: Icons.share_outlined,
        onTap: () {
          // TODO: Share conversation
        },
      ),
      const DesktopContextMenuItem.divider(),
      DesktopContextMenuItem(
        label: 'Delete',
        icon: Icons.delete_outline,
        isDestructive: true,
        onTap: () async {
          final confirmed = await _showDeleteConfirmDialog(context, conversation);
          if (confirmed == true) {
            await chatService.deleteConversation(conversation.id);
          }
        },
      ),
    ];
  }

  Future<void> _showRenameDialog(BuildContext context, Conversation conversation) async {
    final controller = TextEditingController(text: conversation.title);
    final chatService = context.read<ChatService>();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Conversation'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter new name',
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                // TODO: Implement updateConversation
                // chatService.updateConversation(
                //   conversation.id,
                //   title: value.trim(),
                // );
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  // TODO: Implement updateConversation
                  // chatService.updateConversation(
                  //   conversation.id,
                  //   title: controller.text.trim(),
                  // );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context, Conversation conversation) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Conversation?'),
          content: const Text(
            'This action cannot be undone. The conversation and all its messages will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chatService = context.watch<ChatService>();
    final userProvider = context.watch<UserProvider>();
    final assistantProvider = context.watch<AssistantProvider>();

    final conversations = chatService.getAllConversations();
    final filteredConversations = _searchQuery.isEmpty
        ? conversations
        : conversations
            .where((c) => c.title.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header with user info
          _buildHeader(context, userProvider, assistantProvider),

          // Search bar
          Padding(
            padding: EdgeInsets.all(AppSizes.lg),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.md,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // New conversation button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: widget.onNewConversation,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Conversation'),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.lg,
                    vertical: AppSizes.lg,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: AppSizes.lg),

          // Conversations list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
              itemCount: filteredConversations.length,
              itemBuilder: (context, index) {
                final conversation = filteredConversations[index];
                return _buildConversationItem(context, conversation, chatService);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    UserProvider userProvider,
    AssistantProvider assistantProvider,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // User avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                userProvider.name.isNotEmpty
                    ? userProvider.name[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  fontSize: AppSizes.fontSize16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProvider.name,
                  style: TextStyle(
                    fontSize: AppSizes.fontSize14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  assistantProvider.currentAssistant?.name ?? 'Assistant',
                  style: TextStyle(
                    fontSize: AppSizes.fontSize12,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 20),
            tooltip: 'Settings',
            onPressed: () {
              // Open settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(
    BuildContext context,
    Conversation conversation,
    ChatService chatService,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = chatService.currentConversationId == conversation.id;
    final isHovered = _hoveredConversationId == conversation.id;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredConversationId = conversation.id),
      onExit: (_) => setState(() => _hoveredConversationId = ''),
      child: DesktopContextMenuRegion(
        items: _buildConversationContextMenu(context, conversation),
        child: Container(
          margin: EdgeInsets.only(bottom: AppSizes.xs),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer
                : isHovered
                    ? colorScheme.surfaceVariant.withOpacity(0.5)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.xs,
            ),
            leading: Icon(
              conversation.isPinned ? Icons.push_pin : Icons.chat_bubble_outline,
              size: 18,
              color: isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface.withOpacity(0.7),
            ),
            title: Text(
              conversation.title,
              style: TextStyle(
                fontSize: AppSizes.fontSize14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: isHovered
                ? IconButton(
                    icon: const Icon(Icons.more_vert, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    onPressed: () {
                      final RenderBox button = context.findRenderObject() as RenderBox;
                      final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                      final position = button.localToGlobal(
                        button.size.centerRight(Offset.zero),
                        ancestor: overlay,
                      );

                      showDesktopContextMenu(
                        context: context,
                        position: position,
                        items: _buildConversationContextMenu(context, conversation),
                      );
                    },
                  )
                : null,
            onTap: () {
              widget.onSelectConversation?.call(conversation.id);
            },
          ),
        ),
      ),
    );
  }
}
