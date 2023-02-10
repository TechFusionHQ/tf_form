import 'package:flutter/material.dart';

/// TFForm style object is used for styling
class TFFormStyle {
  final Color backgroundColor;
  final Color activeColor;
  final Color errorColor;
  final TextStyle? titleStyle;
  final TextStyle errorStyle;
  final TFFieldStyle fieldStyle;
  final TFGroupStyle groupStyle;

  const TFFormStyle({
    this.backgroundColor = Colors.white,
    this.activeColor = const Color(0xFF0084FF),
    this.errorColor = const Color(0xFFE82C2B),
    this.titleStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),    
    this.errorStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    this.fieldStyle = const TFFieldStyle(),
    this.groupStyle = const TFGroupStyle(),
  });

  TFFormStyle copyWith({
    Color? backgroundColor,
    Color? activeColor,
    Color? errorColor,
    TextStyle? titleStyle,
    TextStyle? errorStyle,
    TFFieldStyle? fieldStyle,
    TFGroupStyle? groupStyle,
  }) {
    return TFFormStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      errorColor: errorColor ?? this.errorColor,
      titleStyle: titleStyle ?? this.titleStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      fieldStyle: fieldStyle ?? this.fieldStyle,
      groupStyle: groupStyle ?? this.groupStyle,
    );
  }
}

/// The style of field widgets
class TFFieldStyle {
  final double? height;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final EdgeInsets? contentPadding;
  final TextStyle? contentStyle;
  final TextStyle? hintStyle;

  const TFFieldStyle({
    this.height,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.contentPadding,
    this.contentStyle,
    this.hintStyle,
  });
}

/// The style of checkbox/raido group widgets
class TFGroupStyle {
  final TextStyle? itemTitleStyle;
  final Color? unselectedColor;

  const TFGroupStyle({
    this.itemTitleStyle,
    this.unselectedColor,
  });
}
