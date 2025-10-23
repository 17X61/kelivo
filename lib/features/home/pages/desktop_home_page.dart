import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/platform_extension.dart';
import '../../../core/sizes.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/chat_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/providers/assistant_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/services/chat/chat_service.dart';
import '../widgets/side_drawer.dart';
import '../../../core/models/conversation.dart';

/// Desktop-specific home page with permanent sidebar and responsive layout
/// Based on AppFlowy's desktop architecture
class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _sidebarVisible = true;
  double _sidebarWidth = 280.0;
  static const double _minSidebarWidth = 200.0;
  static const double _maxSidebarWidth = 400.0;
  static const double _resizerWidth = 4.0;

  @override
  void initState() {
    super.initState();
    // Load saved sidebar width from settings if needed
    _loadSidebarState();
  }

  void _loadSidebarState() {
    // You can load from SharedPreferences or SettingsProvider here
    // For now using default values
  }

  void _toggleSidebar() {
    setState(() {
      _sidebarVisible = !_sidebarVisible;
    });
  }

  Widget _buildSidebarResizer() {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final newWidth = _sidebarWidth + details.delta.dx;
            _sidebarWidth = newWidth.clamp(_minSidebarWidth, _maxSidebarWidth);
          });
        },
        child: Container(
          width: _resizerWidth,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 1,
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        // Sidebar
        if (_sidebarVisible) ...[
          SizedBox(
            width: _sidebarWidth,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Consumer3<ChatService, UserProvider, AssistantProvider>(
                builder: (context, chatService, userProvider, assistantProvider, child) {
                  return SideDrawer(
                    userName: userProvider.name,
                    assistantName: assistantProvider.currentAssistant?.name ?? 'Assistant',
                    embedded: true,
                    embeddedWidth: _sidebarWidth,
                    onSelectConversation: (id) {
                      // Handle conversation selection
                      // ChatService doesn't have switchToConversation, we'll need to implement this differently
                    },
                    onNewConversation: () async {
                      // Handle new conversation
                      await chatService.createConversation();
                    },
                    loadingConversationIds: const {},
                  );
                },
              ),
            ),
          ),
          _buildSidebarResizer(),
        ],
        
        // Main content area
        Expanded(
          child: _buildMainContent(context),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.background,
      appBar: _buildDesktopAppBar(context),
      body: _buildChatArea(context),
    );
  }

  PreferredSizeWidget _buildDesktopAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final assistant = context.watch<AssistantProvider>().currentAssistant;
    final chatService = context.watch<ChatService>();
    final currentConvoId = chatService.currentConversationId;
    final currentConvo = currentConvoId != null ? chatService.getConversation(currentConvoId) : null;

    return AppBar(
      toolbarHeight: HomeSizes.desktopTopBarHeight,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: !_sidebarVisible
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: _toggleSidebar,
              tooltip: 'Show Sidebar',
            )
          : null,
      title: Row(
        children: [
          if (_sidebarVisible)
            IconButton(
              icon: const Icon(Icons.menu_open),
              onPressed: _toggleSidebar,
              iconSize: 20,
              tooltip: 'Hide Sidebar',
            ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: Text(
              currentConvo?.title ?? assistant?.name ?? 'Kelivo',
              style: TextStyle(
                fontSize: AppSizes.fontSize16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        // Model selector
        IconButton(
          icon: const Icon(Icons.smart_toy_outlined),
          iconSize: 20,
          tooltip: 'Select Model',
          onPressed: () {
            // Show model selector
          },
        ),
        SizedBox(width: AppSizes.sm),
        
        // Assistant selector
        IconButton(
          icon: const Icon(Icons.person_outline),
          iconSize: 20,
          tooltip: 'Select Assistant',
          onPressed: () {
            // Show assistant selector
          },
        ),
        SizedBox(width: AppSizes.sm),
        
        // Settings
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          iconSize: 20,
          tooltip: 'Settings',
          onPressed: () {
            // Navigate to settings
          },
        ),
        SizedBox(width: AppSizes.lg),
      ],
    );
  }

  Widget _buildChatArea(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: HomeSizes.maxContentWidth,
        ),
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(context),
            ),
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    final chatService = context.watch<ChatService>();
    final currentConvoId = chatService.currentConversationId;
    
    if (currentConvoId == null) {
      return _buildEmptyState(context);
    }
    
    final currentConvo = chatService.getConversation(currentConvoId);
    if (currentConvo == null) {
      return _buildEmptyState(context);
    }
    
    // TODO: Implement message list
    // This should display messages from the current conversation
    // You can reuse the message rendering logic from the mobile HomePage
    return ListView.builder(
      padding: EdgeInsets.all(ChatSizes.messageHorizontalPadding),
      itemCount: 0, // Replace with actual message count
      itemBuilder: (context, index) {
        // TODO: Build message widgets
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          SizedBox(height: AppSizes.xxl),
          Text(
            'Welcome to Kelivo',
            style: TextStyle(
              fontSize: AppSizes.fontSize24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: AppSizes.lg),
          Text(
            'Start a conversation or select one from the sidebar',
            style: TextStyle(
              fontSize: AppSizes.fontSize14,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: EdgeInsets.all(ChatSizes.inputBarPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            icon: const Icon(Icons.attach_file),
            iconSize: 20,
            tooltip: 'Attach File',
            onPressed: () {
              // Handle file attachment
            },
          ),
          
          SizedBox(width: AppSizes.sm),
          
          // Input field
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                minHeight: ChatSizes.inputBarMinHeight,
                maxHeight: ChatSizes.inputBarMaxHeight,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ChatSizes.inputBarPadding,
                    vertical: AppSizes.lg,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(width: AppSizes.sm),
          
          // Send button
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 20,
            tooltip: 'Send',
            onPressed: () {
              // Handle send
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDesktopLayout(context);
  }
}
