part of 'tf_form.dart';

/// Error text widget
class TFErrorText extends StatelessWidget {
  const TFErrorText({
    Key? key,
    required this.error,
    required this.visible,
  }) : super(key: key);

  final String error;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          error,
          style: _tffStyle.errorStyle.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
