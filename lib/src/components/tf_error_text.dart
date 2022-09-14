part of 'tf_form.dart';

/// Error text widget
class TFErrorText extends StatelessWidget {
  final String error;
  final bool visible;

  const TFErrorText({
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
              color: _tffStyle.errorColor,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                error,
                style: TextStyle(
                  color: _tffStyle.errorColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
