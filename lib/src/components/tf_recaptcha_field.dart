part of 'tf_form.dart';

/// [TFRecaptchaField] widget allows the user to pick a DateTime from an input field
class TFRecaptchaField extends StatefulWidget {
  TFRecaptchaField({
    Key? key,
    required this.controller,
    required this.uri,
  }) : super(key: key);

  final TextEditingController controller;
  final String jsChannelName = 'tf_form';
  Uri uri = Uri.parse("https://www.anhcode.com/recaptcha.html");

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
