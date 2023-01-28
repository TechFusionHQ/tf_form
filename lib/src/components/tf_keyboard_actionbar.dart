import 'package:flutter/cupertino.dart';

class TFKeyboardActionBar {
  static OverlayEntry? _overlayEntry;

  static void showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: const KeyboardActionBarWidget(),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}

class KeyboardActionBarWidget extends StatelessWidget {
  const KeyboardActionBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      color: const Color(0xFFf0F0F2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildDoneButton(context),
        ],
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8,
      ),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: const Text(
        "Done",
        style: TextStyle(
          color: Color(0XFF3994F9),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
