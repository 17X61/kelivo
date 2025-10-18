import 'package:flutter/cupertino.dart';

// iOS风格的动画曲线和持续时间
class IOSAnimations {
  // iOS标准动画曲线
  static const Curve standardCurve = Curves.easeInOut;
  static const Curve sharpCurve = Curves.easeOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  
  // iOS标准动画持续时间
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration long = Duration(milliseconds: 500);
  
  // 弹性动画（用于按钮等交互）
  static const Curve spring = Curves.elasticOut;
  static const Duration springDuration = Duration(milliseconds: 400);
  
  // 页面转场动画
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Curve pageTransitionCurve = Curves.easeInOut;
  
  // 滚动动画
  static const Duration scrollAnimation = Duration(milliseconds: 300);
  static const Curve scrollCurve = Curves.easeOut;
  
  // 对话框动画
  static const Duration dialogAnimation = Duration(milliseconds: 250);
  static const Curve dialogCurve = Curves.easeOut;
  
  // 底部表单动画
  static const Duration sheetAnimation = Duration(milliseconds: 350);
  static const Curve sheetCurve = Curves.easeOut;
}

// iOS风格的交互反馈
class IOSInteraction {
  // 按钮按下缩放
  static const double pressScale = 0.95;
  static const Duration pressAnimationDuration = Duration(milliseconds: 100);
  
  // 长按缩放
  static const double longPressScale = 0.97;
  
  // 触觉反馈延迟
  static const Duration hapticDelay = Duration(milliseconds: 10);
}
