import 'package:flutter/material.dart';

class UIConstants {
  /// 圆角统一为 8
  static const BorderRadius borderRadius8 = BorderRadius.all(Radius.circular(8));

  /// 常用 padding
  static const EdgeInsets pagePadding = EdgeInsets.only(left: 40, right: 40);

  /// 按钮最小高度
  static const double buttonHeight = 48;
  /// 文本框最小高度
  static const double textFieldHeight = 36;

  /// 常用颜色
  static const Color primaryColor = Color(0xFF3F51B5);

  /// 统一阴影
  static final List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];

  /// 字体大小
  static const double titleFontSize = 28;
  static const double subtitleFontSize = 16;
}
