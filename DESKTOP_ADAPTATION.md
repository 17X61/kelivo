# Desktop Adaptation Guide

本文档说明了 Kelivo 项目的桌面端适配实现，遵循 AppFlowy 的架构模式。

## 核心组件

### 1. 平台检测 (`lib/core/platform_extension.dart`)

提供统一的平台检测工具：

```dart
// 检测桌面端
if (PlatformExtension.isDesktop) { }

// 检测移动端
if (PlatformExtension.isMobile) { }

// 检测特定平台
if (PlatformExtension.isWindows) { }
if (PlatformExtension.isMacOS) { }
if (PlatformExtension.isLinux) { }
```

### 2. 尺寸系统 (`lib/core/sizes.dart`)

平台自适应的尺寸常量：

```dart
// 自动根据平台调整
HomeSizes.topBarHeight      // 桌面: 44px, 移动: 56px
HomeSizes.buttonHeight       // 桌面: 36px, 移动: 48px
ChatSizes.messageSpacing     // 桌面更紧凑，移动更宽松
```

### 3. 桌面端右键菜单 (`lib/shared/widgets/desktop_context_menu.dart`)

#### 基本用法

```dart
// 显示右键菜单
showDesktopContextMenu(
  context: context,
  position: details.globalPosition,
  items: [
    DesktopContextMenuItem(
      label: 'Copy',
      icon: Icons.copy_outlined,
      onTap: () { /* 处理复制 */ },
    ),
    const DesktopContextMenuItem.divider(),
    DesktopContextMenuItem(
      label: 'Delete',
      icon: Icons.delete_outline,
      isDestructive: true,
      onTap: () { /* 处理删除 */ },
    ),
  ],
);
```

#### 右键菜单区域

```dart
DesktopContextMenuRegion(
  items: [/* 菜单项 */],
  child: YourWidget(),
)
```

#### 下拉菜单按钮

```dart
DesktopDropdownMenuButton<String>(
  label: '选择选项',
  value: currentValue,
  items: [
    DesktopDropdownMenuItem(
      value: 'option1',
      label: '选项 1',
      icon: Icons.star,
    ),
  ],
  onChanged: (value) { },
)
```

### 4. 平台对话框 (`lib/shared/widgets/platform_dialog.dart`)

#### 自适应对话框

桌面端显示为对话框，移动端显示为底部弹窗：

```dart
// 通用对话框
showPlatformDialog(
  context: context,
  title: '标题',
  content: Text('内容'),
  actions: [
    TextButton(onPressed: () {}, child: Text('取消')),
    FilledButton(onPressed: () {}, child: Text('确定')),
  ],
);

// 确认对话框
final confirmed = await showPlatformConfirmDialog(
  context: context,
  title: '删除确认',
  message: '确定要删除吗？',
  isDestructive: true,
);

// 输入对话框
final result = await showPlatformInputDialog(
  context: context,
  title: '重命名',
  hint: '输入新名称',
  initialValue: '当前名称',
);

// 选择器
final selected = await showPlatformSelector<String>(
  context: context,
  title: '选择选项',
  items: [
    PlatformSelectorItem(
      value: 'option1',
      label: '选项 1',
      icon: Icons.star,
    ),
  ],
  currentValue: 'option1',
);
```

### 5. 桌面端组件

#### 聊天消息组件 (`lib/features/chat/widgets/desktop_chat_message_widget.dart`)

```dart
DesktopChatMessageWidget(
  message: message,
  onCopy: () { },
  onEdit: () { },
  onDelete: () { },
  onRegenerate: () { },
  // 自动支持右键菜单和悬停工具栏
)
```

特点：
- 鼠标悬停显示操作按钮
- 右键显示完整上下文菜单
- 移除长按操作
- 优化桌面端交互

#### 侧边栏 (`lib/features/home/widgets/desktop_side_drawer.dart`)

```dart
DesktopSideDrawer(
  width: 280,
  onNewConversation: () { },
  onSelectConversation: (id) { },
  // 自动支持会话右键菜单
)
```

特点：
- 右键会话显示菜单（固定、重命名、导出、分享、删除）
- 悬停显示更多按钮
- 搜索功能
- 用户信息展示

#### 设置页面 (`lib/features/settings/pages/desktop_settings_page.dart`)

```dart
DesktopSettingsPage()
```

特点：
- 侧边栏导航
- 分栏布局
- 使用下拉菜单而非底部弹窗

#### 助手选择器 (`lib/features/assistant/widgets/desktop_assistant_selector.dart`)

```dart
DesktopAssistantSelector(
  assistants: assistants,
  selectedAssistant: current,
  onSelect: (assistant) { },
  onManageAssistants: () { },
)
```

#### 模型选择器 (`lib/features/model/widgets/desktop_model_selector.dart`)

```dart
DesktopModelSelector(
  selectedProvider: 'openai',
  selectedModel: 'gpt-4',
  onSelect: (provider, model) { },
  onManageModels: () { },
)
```

### 6. 平台 Widget 封装 (`lib/shared/widgets/platform_widget.dart`)

#### 基于平台的条件渲染

```dart
PlatformWidget(
  mobile: MobileLayout(),
  desktop: DesktopLayout(),
)
```

#### 基于屏幕宽度的响应式渲染

```dart
ResponsiveWidget(
  mobile: SmallLayout(),
  tablet: MediumLayout(),
  desktop: LargeLayout(),
)
```

#### 平台特定值

```dart
final padding = PlatformValue(
  mobile: 20.0,
  desktop: 16.0,
).value;
```

## 主要差异对比

### 交互方式

| 功能 | 移动端 | 桌面端 |
|------|--------|--------|
| 消息操作 | 长按弹出菜单 | 右键菜单 + 悬停工具栏 |
| 会话操作 | 长按弹出底部弹窗 | 右键菜单 |
| 设置选择 | 底部弹窗 | 下拉菜单 |
| 侧边栏 | 抽屉式 | 永久显示 + 可调整大小 |
| 对话框 | 底部弹窗 | 居中对话框 |

### UI 尺寸

| 元素 | 移动端 | 桌面端 |
|------|--------|--------|
| AppBar 高度 | 56px | 44px |
| 按钮高度 | 48px | 36px |
| 触摸目标 | 44px | 32px |
| 字体大小 | 较大 | 较小 |
| 间距 | 更宽松 | 更紧凑 |

### 布局结构

**移动端：**
- 单列布局
- 全屏页面
- 抽屉式侧边栏
- 底部导航

**桌面端：**
- 多列布局
- 永久侧边栏（可调整大小）
- 最大内容宽度限制（1200px）
- 顶部导航栏

## 使用指南

### 1. 判断是否需要平台适配

如果组件涉及以下情况，需要考虑平台适配：

- ✅ 用户交互（点击、长按、右键）
- ✅ 弹窗和对话框
- ✅ 选择器和菜单
- ✅ 尺寸和间距
- ✅ 导航结构

### 2. 选择适配方式

#### 方式 1：条件渲染

```dart
if (PlatformExtension.isDesktop) {
  return DesktopWidget();
} else {
  return MobileWidget();
}
```

#### 方式 2：使用 PlatformWidget

```dart
PlatformWidget(
  mobile: MobileWidget(),
  desktop: DesktopWidget(),
)
```

#### 方式 3：平台特定组件

```dart
// 创建 desktop_xxx.dart 和 mobile_xxx.dart
// 在入口处根据平台导入
```

### 3. 替换移动端特定操作

#### 长按 → 右键菜单

```dart
// 移动端
GestureDetector(
  onLongPress: () {
    showModalBottomSheet(/* ... */);
  },
  child: child,
)

// 桌面端
DesktopContextMenuRegion(
  items: [/* 菜单项 */],
  child: child,
)
```

#### 底部弹窗 → 对话框/菜单

```dart
// 移动端
showModalBottomSheet(
  context: context,
  builder: (context) => /* ... */,
)

// 桌面端（使用平台对话框）
showPlatformDialog(
  context: context,
  title: '标题',
  content: /* ... */,
)

// 或使用下拉菜单
DesktopDropdownMenuButton(/* ... */)
```

### 4. 调整尺寸和间距

```dart
// 不要硬编码尺寸
Container(height: 48.0)  // ❌

// 使用平台自适应尺寸
Container(height: HomeSizes.buttonHeight)  // ✅

// 或使用 PlatformValue
Container(
  height: PlatformValue(
    mobile: 48.0,
    desktop: 36.0,
  ).value,
)
```

## 开发流程

### 创建新功能时

1. **设计阶段**：考虑桌面端和移动端的交互差异
2. **实现阶段**：
   - 先实现核心逻辑（平台无关）
   - 为桌面端和移动端创建不同的 UI 组件
   - 使用平台检测选择正确的组件
3. **测试阶段**：
   - 在桌面端测试（Windows/macOS/Linux）
   - 在移动端测试（Android/iOS）
   - 检查不同屏幕尺寸

### 适配现有功能时

1. 识别移动端特定的操作（长按、底部弹窗等）
2. 创建对应的桌面端组件
3. 使用平台检测或 PlatformWidget 切换
4. 测试两个平台

## 最佳实践

### ✅ 推荐

- 使用 `PlatformExtension` 进行平台检测
- 使用 `AppSizes`、`HomeSizes`、`ChatSizes` 等尺寸常量
- 桌面端优先使用右键菜单
- 使用 `showPlatformDialog` 而非直接调用 `showDialog` 或 `showModalBottomSheet`
- 为桌面端提供键盘快捷键
- 桌面端使用悬停状态提示
- 保持桌面端和移动端的功能一致性

### ❌ 避免

- 硬编码尺寸值
- 在桌面端使用长按操作
- 在桌面端使用底部弹窗（除非明确需要）
- 忽略右键菜单支持
- 在移动端使用过小的触摸目标（< 44px）
- 混用平台检测方式

## 待完善功能

以下功能需要进一步完善桌面端适配：

1. **聊天页面**
   - [ ] 完整的桌面端消息渲染
   - [ ] 键盘快捷键（Ctrl+C 复制、Ctrl+V 粘贴等）
   - [ ] 多选消息
   - [ ] 拖拽附件

2. **设置页面**
   - [ ] 各个设置子页面的桌面端实现
   - [ ] 模型配置界面
   - [ ] 提供商配置界面

3. **助手管理**
   - [ ] 桌面端助手编辑界面
   - [ ] 助手列表右键菜单

4. **MCP 工具**
   - [ ] 桌面端 MCP 配置界面
   - [ ] 工具调用可视化

5. **搜索功能**
   - [ ] 桌面端搜索设置菜单
   - [ ] 搜索结果优化

6. **备份还原**
   - [ ] 桌面端备份界面
   - [ ] 拖拽导入备份文件

## 参考资源

- AppFlowy 源码：https://github.com/AppFlowy-IO/AppFlowy
- Material Design 3 指南
- Flutter 桌面端开发文档

## 联系方式

如有问题或建议，请提交 Issue 或 PR。
