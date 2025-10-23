# Desktop Layout Implementation

This directory contains desktop-specific layouts and widgets for the Kelivo chat client.

## Directory Structure

```
desktop/
├── pages/
│   └── desktop_home_page.dart       # Desktop home page
└── widgets/
    ├── desktop_side_drawer.dart     # Desktop sidebar
    ├── desktop_chat_message_widget.dart  # Desktop message widget (planned)
    └── ...                          # Other desktop widgets (planned)
```

## Design Principles

1. **Mobile First, Desktop Extension**: The mobile implementation in `features/` is the default. Desktop layouts in this folder are additions, not replacements.

2. **Code Sharing**: Core business logic, models, providers, and services in `core/` and `shared/` are shared across all platforms.

3. **Platform-Specific UI**: Only UI interaction patterns differ:
   - Mobile: Bottom sheets, long-press, touch-optimized
   - Desktop: Popup menus, right-click, hover effects, keyboard shortcuts

## Platform Detection

Use `PlatformHelper` from `core/platform_helper.dart`:

```dart
import 'package:your_app/core/platform_helper.dart';

if (PlatformHelper.isDesktop) {
  // Desktop-specific code
} else if (PlatformHelper.isMobile) {
  // Mobile-specific code
}
```

## Key Differences from Mobile

### Interaction Patterns

| Mobile | Desktop |
|--------|---------|
| Bottom sheets | Popup menus / Dialogs |
| Long press | Right-click context menu |
| Touch targets (48dp) | Smaller targets with hover |
| Swipe gestures | Mouse wheel / keyboard |
| Drawer (slide-in) | Fixed sidebar |

### Layout

- **Mobile**: InteractiveDrawer with swipe-to-open sidebar
- **Tablet/Desktop**: Fixed embedded sidebar (300px width)
- **Content area**: Constrained to 860px max width for readability

## Implementation Status

### Phase 1: Basic Structure ✅
- [x] Platform detection helper (`core/platform_helper.dart`)
- [x] Desktop folder structure
- [x] Desktop home page (initial wrapper)
- [x] Desktop sidebar (initial wrapper)
- [x] Main.dart routing based on platform

### Phase 2: Home Page Adaptation (Current)
- [ ] Desktop-optimized message list
- [ ] Right-click context menu for messages (replace long-press)
- [ ] Hover effects on buttons and interactive elements
- [ ] Popup menus instead of bottom sheets for:
  - [ ] Message "More" actions
  - [ ] Message "Translate" button
  - [ ] Conversation context menu (sidebar)
  - [ ] User avatar menu (sidebar)

### Phase 3: Additional Pages (Future)
- [ ] Settings page adaptation
- [ ] Assistant settings page
- [ ] Model selection dialog
- [ ] Search page
- [ ] Other feature pages

## Usage

### From main.dart

```dart
import 'core/platform_helper.dart';
import 'features/home/pages/home_page.dart';
import 'desktop/pages/desktop_home_page.dart';

// In MaterialApp
home: PlatformHelper.isDesktop 
  ? const DesktopHomePage() 
  : const HomePage(),
```

### Creating Desktop Widgets

When creating desktop-specific widgets, follow this pattern:

```dart
// desktop/widgets/desktop_my_widget.dart
import 'package:flutter/material.dart';
import '../../features/some_feature/widgets/my_widget.dart';
import '../../core/platform_helper.dart';

class DesktopMyWidget extends StatelessWidget {
  // ... desktop-specific implementation
  
  @override
  Widget build(BuildContext context) {
    // Desktop-optimized UI with:
    // - Hover effects
    // - Right-click menus
    // - Popup menus instead of bottom sheets
    // - Keyboard shortcuts
  }
}
```

## Font Adaptation

Desktop platforms generally use smaller font sizes and tighter spacing:

- Mobile: Base font 15-16sp, larger touch targets
- Desktop: Base font 13-14sp, compact UI with hover states

## Notes

- The existing HomePage already has tablet layout support (width >= 900px)
- Tablet layout uses embedded sidebar which works well for desktop
- Current implementation reuses tablet layout as a starting point
- Future iterations will add desktop-specific interactions (right-click, hover, etc.)
