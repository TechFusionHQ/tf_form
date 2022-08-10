// Copyright (c) 2022 TechFusion Ltd (https://www.techfusion.dev).

import 'package:flutter/material.dart';
import 'package:tf_form/tf_form.dart';

class TFFormColors {
  static const defaultBackground = Colors.white;
  static const defaultActive = Color(0xFF0084FF);
  static const defaultError = Color(0xFFE82C2B);

  static Color backgroundColor(BuildContext context) {
    return TFForm.of(context)?.widget.backgroundColor ?? defaultBackground;
  }

  static Color activeColor(BuildContext context) {
    return TFForm.of(context)?.widget.activeColor ?? defaultActive;
  }

  static Color errorColor(BuildContext context) {
    return TFForm.of(context)?.widget.errorColor ?? defaultError;
  }
}

class TFErrorWidget extends StatelessWidget {
  final String error;
  final bool visible;

  const TFErrorWidget({
    Key? key,
    required this.error,
    required this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error,
              size: 16,
              color: TFForm.of(context)?.widget.errorColor ??
                  TFFormColors.defaultError,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                error,
                style: TextStyle(
                  color: TFForm.of(context)?.widget.errorColor ??
                      TFFormColors.defaultError,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const TitleWidget({
    Key? key,
    required this.title,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style ??
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}
