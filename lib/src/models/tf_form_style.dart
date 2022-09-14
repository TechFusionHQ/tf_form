import 'package:flutter/material.dart';
import 'package:tf_form/src/components/tf_form.dart';

/// TFForm style object is used for styling
class TFFormStyle {
  final Color backgroundColor;
  final Color activeColor;
  final Color errorColor;
  final TextStyle? titleStyle;
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
    this.fieldStyle = const TFFieldStyle(),
    this.groupStyle = const TFGroupStyle(),
  });

  static TFFormStyle of(BuildContext context) {
    return TFForm.of(context)?.widget.style ?? const TFFormStyle();
  }
}

/// The style of field widgets
class TFFieldStyle {
  final double height;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final EdgeInsets contentPadding;
  final TextStyle? contentStyle;
  final TextStyle? hintStyle;

  const TFFieldStyle({
    this.height = 48,
    this.borderRadius = 10,
    this.borderWidth = 1,
    this.borderColor = const Color(0x1F000000),
    this.contentPadding = const EdgeInsets.only(
      left: 10,
      right: 10,
      top: 5,
      bottom: 5,
    ),
    this.contentStyle,
    this.hintStyle,
  });
}

/// The style of checkbox/raido group widgets
class TFGroupStyle {
  final TextStyle itemTitleStyle;
  final Color unselectedColor;

  const TFGroupStyle({
    this.itemTitleStyle = const TextStyle(fontSize: 16),
    this.unselectedColor = Colors.black,
  });
}
