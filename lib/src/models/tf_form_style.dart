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
    this.height = 50,
    this.radius = 10,
    this.borderWidth = 1,
    this.borderColor = Colors.grey,
    this.focusBorderColor = Colors.lightBlueAccent,
    this.backgroundColor = Colors.white,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 10),
    this.contentStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    this.hintStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    this.titleStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  });

  final double height;
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final Color focusBorderColor;
  final Color backgroundColor;
  final EdgeInsets contentPadding;
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final TextStyle hintStyle;
}

/// The style of checkbox/raido group widgets
class TFGroupStyle {
  const TFGroupStyle({
    this.titleStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    this.itemTitleStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    this.unselectedColor = Colors.black87,
  });

  final TextStyle titleStyle;
  final TextStyle itemTitleStyle;
  final Color unselectedColor;
}
