# iOS化迁移指南

本文档描述了将Kelivo应用完全iOS化所做的更改。

## 主要变更

### 1. 应用层面 (main.dart)

- **CupertinoApp**: 将 `MaterialApp` 替换为 `CupertinoApp`，提供iOS原生外观
- **iOS主题**: 添加了 `buildCupertinoLightTheme` 和 `buildCupertinoDarkTheme` 函数
- **Material兼容**: 在builder中包装 `Theme` widget以保持Material组件兼容性
- **本地化**: 添加了 `DefaultCupertinoLocalizations.delegate`

### 2. 主题系统 (theme/theme_factory.dart)

新增两个Cupertino主题构建函数：
- `buildCupertinoLightTheme(ColorScheme scheme)`
- `buildCupertinoDarkTheme(ColorScheme scheme)`

这些函数从Material的ColorScheme创建对应的CupertinoThemeData，确保颜色一致性。

### 3. iOS风格动画 (theme/ios_animations.dart)

定义了iOS标准的动画参数：
- 动画曲线: standardCurve, sharpCurve, smoothCurve, spring
- 动画持续时间: short (200ms), medium (350ms), long (500ms)
- 页面转场: 350ms with easeInOut
- 对话框/底部表单动画参数

### 4. 路由系统 (utils/ios_page_route.dart)

提供iOS风格的页面路由：
- `IOSPageRoute.push()`: 标准页面推送
- `IOSPageRoute.pushModal()`: 模态页面
- `IOSPageRoute.pushReplacement()`: 替换当前页面
- `IOSPageRoute.createRoute()`: 创建iOS风格路由

所有路由使用 `CupertinoPageRoute` 实现iOS特有的右滑返回手势。

### 5. iOS风格组件库 (shared/widgets/)

#### 对话框 (ios_dialog.dart)
- `IOSDialog.showAlert()`: iOS样式提示框
- `IOSDialog.showConfirm()`: iOS样式确认框
- `IOSDialog.showActionSheet()`: iOS样式操作表

#### 按钮 (ios_button.dart)
- `IOSButton`: 主要按钮（带背景色）
- `IOSTextButton`: 文本按钮
- `IOSIconButton`: 图标按钮
- `IOSFilledButton`: 填充按钮

#### 输入框 (ios_text_field.dart)
- `IOSTextField`: iOS样式文本输入框
- `IOSSearchField`: iOS样式搜索框

#### 控件 (ios_controls.dart)
- `IOSSwitch`: iOS开关
- `IOSSlider`: iOS滑块
- `IOSSegmentedControl`: 分段控制器
- `IOSCheckbox`: iOS复选框
- `IOSRadio`: iOS单选按钮
- `IOSActivityIndicator`: iOS活动指示器

#### 列表 (ios_list.dart)
- `IOSListTile`: iOS列表项
- `IOSListSection`: iOS分组列表
- `IOSCard`: iOS卡片
- `IOSDivider`: iOS分隔线

#### 底部表单 (ios_bottom_sheet.dart)
- `IOSBottomSheet.show()`: 显示底部表单
- `IOSBottomSheet.showScrollable()`: 可滚动底部表单
- `IOSModalSheet`: 全屏模态表单

#### 导航 (ios_navigation.dart)
- `IOSTabScaffold`: iOS标签栏脚手架
- `IOSSegmentedTabBar`: 顶部分段标签栏
- `IOSBackButton`: iOS返回按钮
- `IOSSidebar`: iOS侧边栏

#### 通知 (ios_notifications.dart)
- `IOSNotificationBanner`: iOS通知横幅
- `IOSToast`: iOS Toast提示

#### Scaffold (ios_scaffold.dart)
- `IOSScaffold`: iOS页面脚手架
- `IOSNavigationBar`: iOS导航栏

## 使用指南

### 基本页面结构

```dart
import 'package:flutter/cupertino.dart';
import '../shared/widgets/ios_widgets.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IOSScaffold(
      navigationBar: IOSNavigationBar(
        middle: Text('页面标题'),
        leading: IOSBackButton(),
        actions: [
          IOSIconButton(
            icon: CupertinoIcons.add,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: // 你的内容
      ),
    );
  }
}
```

### 导航到新页面

```dart
// 标准推送
IOSPageRoute.push(context, MyNewPage());

// 模态页面
IOSPageRoute.pushModal(context, MyModalPage());
```

### 显示对话框

```dart
// 提示
IOSDialog.showAlert(
  context: context,
  title: '提示',
  content: '这是一个iOS风格的提示框',
);

// 确认
final confirmed = await IOSDialog.showConfirm(
  context: context,
  title: '确认',
  content: '确定要删除吗？',
  isDestructive: true,
);
```

### 显示底部表单

```dart
IOSBottomSheet.show(
  context: context,
  builder: (ctx) => Container(
    padding: EdgeInsets.all(16),
    child: // 你的内容
  ),
);
```

### 表单控件

```dart
// 输入框
IOSTextField(
  placeholder: '请输入',
  controller: myController,
)

// 开关
IOSSwitch(
  value: isEnabled,
  onChanged: (value) {
    setState(() => isEnabled = value);
  },
)

// 滑块
IOSSlider(
  value: volume,
  min: 0,
  max: 100,
  onChanged: (value) {
    setState(() => volume = value);
  },
)
```

## 动画使用

使用预定义的iOS动画参数以保持一致性：

```dart
import '../theme/ios_animations.dart';

AnimatedContainer(
  duration: IOSAnimations.medium,
  curve: IOSAnimations.smoothCurve,
  // ...
)
```

## 迁移现有代码

### Material组件到Cupertino组件对照表

| Material | Cupertino/iOS |
|----------|---------------|
| MaterialApp | CupertinoApp |
| Scaffold | IOSScaffold / CupertinoPageScaffold |
| AppBar | IOSNavigationBar / CupertinoNavigationBar |
| AlertDialog | CupertinoAlertDialog / IOSDialog |
| BottomSheet | IOSBottomSheet |
| RaisedButton/ElevatedButton | IOSButton |
| TextButton | IOSTextButton |
| IconButton | IOSIconButton |
| TextField | IOSTextField / CupertinoTextField |
| Switch | IOSSwitch / CupertinoSwitch |
| Slider | IOSSlider / CupertinoSlider |
| CircularProgressIndicator | IOSActivityIndicator |
| ListTile | IOSListTile |
| Card | IOSCard |
| Checkbox | IOSCheckbox |
| Radio | IOSRadio |

## 注意事项

1. **Material兼容性**: 应用仍然在builder中包装了Material和Theme，所以现有的Material组件仍可正常工作
2. **渐进式迁移**: 可以逐步将Material组件替换为iOS组件
3. **颜色一致性**: iOS主题从Material的ColorScheme派生，确保颜色一致
4. **字体**: 使用PingFang SC等CJK字体作为后备，确保中文显示正常
5. **手势**: CupertinoPageRoute自动支持iOS的右滑返回手势

## 性能优化

- 使用IOSAnimations预定义参数可以获得更好的性能
- Cupertino组件通常比Material组件更轻量
- 页面转场动画使用原生iOS风格，更流畅

## 后续工作

如需进一步iOS化，可以考虑：
1. 将所有showModalBottomSheet替换为IOSBottomSheet
2. 将所有showDialog替换为IOSDialog
3. 将所有Material按钮替换为iOS按钮
4. 使用CupertinoContextMenu替代长按菜单
5. 使用CupertinoPicker替代下拉选择器
