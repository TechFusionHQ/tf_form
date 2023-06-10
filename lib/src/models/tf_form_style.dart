import 'package:flutter/material.dart';

/// TFForm style object is used for styling
class TFFormStyle {
  const TFFormStyle({
    this.titleStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    this.errorStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    this.fieldStyle = const TFFieldStyle(),
    this.groupStyle = const TFGroupStyle(),
  });

  final TextStyle titleStyle;
  final TextStyle errorStyle;
  final TFFieldStyle fieldStyle;
  final TFGroupStyle groupStyle;

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
///  height : 48,

class TFFieldStyle {
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

  final double? height;
  final double? radius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final TextStyle? titleStyle;

  // Must declare fontSize and fontHeight for contentStyle
  final TextStyle? contentStyle;

  final TextStyle? hintStyle;

  TFFieldStyle copyWith({TFFieldStyle? fieldStyle}) {
    return TFFieldStyle(
      height: fieldStyle?.height ?? height,
      radius: fieldStyle?.radius ?? radius,
      borderWidth: fieldStyle?.borderWidth ?? borderWidth,
      borderColor: fieldStyle?.borderColor ?? borderColor,
      focusBorderColor: fieldStyle?.focusBorderColor ?? focusBorderColor,
      backgroundColor: fieldStyle?.backgroundColor ?? backgroundColor,
      contentPadding: fieldStyle?.contentPadding ?? contentPadding,
      titleStyle: fieldStyle?.titleStyle ?? titleStyle,
      contentStyle: fieldStyle?.contentStyle ?? contentStyle,
      hintStyle: fieldStyle?.hintStyle ?? hintStyle,
    );
  }
}

/// The style of checkbox/raido group widgets
class TFGroupStyle {
  const TFGroupStyle({
    this.titleStyle,
    this.itemTitleStyle,
    this.unselectedColor,
  });

  final TextStyle? titleStyle;
  final TextStyle? itemTitleStyle;
  final Color? unselectedColor;

  TFGroupStyle copyWith({TFGroupStyle? groupStyle}) {
    return TFGroupStyle(
      titleStyle: groupStyle?.titleStyle ?? titleStyle,
      itemTitleStyle: groupStyle?.itemTitleStyle ?? itemTitleStyle,
      unselectedColor: groupStyle?.unselectedColor ?? unselectedColor,
    );
  }
}
