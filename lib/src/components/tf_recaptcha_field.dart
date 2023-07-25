part of 'tf_form.dart';

/// [TFRecaptchaField] widget allows loading Google's reCAPTCHA v3 token and set to a TextEditingController's instance
class TFRecaptchaField extends StatefulWidget {
  const TFRecaptchaField({
    Key? key,
    required this.controller,
    required this.uri,
  }) : super(key: key);

  final TextEditingController controller;
  final String jsChannelName = 'tf_form';
  final Uri uri;

  @override
  State<TFRecaptchaField> createState() => _TFRecaptchaFieldState();
}

class _TFRecaptchaFieldState extends State<TFRecaptchaField> {
  late WebViewController _webviewController;

  @override
  void initState() {
    super.initState();
    _webviewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        widget.jsChannelName,
        onMessageReceived: (message) {
          debugPrint("recaptcha token: ${message.message}");
          widget.controller.text = message.message;
        },
      )
      ..loadRequest(widget.uri);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0,
      child: WebViewWidget(
        controller: _webviewController,
      ),
    );
  }
}
