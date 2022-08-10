import 'package:flutter/material.dart';

class TFFormColors {
  static const backgroundColor = Colors.white;
  static const activeColor = Color(0xFF0084FF);
  static const errorColor = Color(0xFFE82C2B);
}

///
///
///
class ErrorTextWidget extends StatelessWidget {
  final String error;
  final bool visible;

  const ErrorTextWidget({
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
            const Icon(
              Icons.error,
              size: 16,
              color: TFFormColors.errorColor,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                error,
                style: const TextStyle(
                  color: TFFormColors.errorColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///
class TitleTextWidget extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const TitleTextWidget({
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
