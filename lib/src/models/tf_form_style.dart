import 'package:flutter/material.dart';

/// TFForm style object is used for styling
class TFFormStyle {
  final TextStyle titleStyle;
  final TextStyle errorStyle;
  final TFFieldStyle fieldStyle;
  final TFGroupStyle groupStyle;

  const TFFormStyle({
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
    TextStyle? titleStyle,
    TextStyle? errorStyle,
    TFFieldStyle? fieldStyle,
    TFGroupStyle? groupStyle,
  }) {
    return TFFormStyle(
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
  final double? radius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final TextStyle? hintStyle;

  const TFFieldStyle({
    this.height,
    this.radius,
    this.borderWidth,
    this.borderColor,
    this.focusBorderColor,
    this.backgroundColor,
    this.contentPadding,
    this.contentStyle,
    this.hintStyle,
    this.titleStyle,
  });
}

/// The style of checkbox/raido group widgets
class TFGroupStyle {
  final TextStyle? titleStyle;
  final TextStyle? itemTitleStyle;
  final Color? unselectedColor;

  const TFGroupStyle({
    this.titleStyle,
    this.itemTitleStyle,
    this.unselectedColor,
  });
}
