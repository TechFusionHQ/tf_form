part of 'tf_form.dart';

/// A single form field.
///
/// This widget maintains the current state of the form field, so that updates
/// and validation errors are visually reflected in the UI.
///
/// A [TFForm] ancestor is required. The [TFForm] simply makes it easier to
/// validate multiple fields at once.
class TFTextField extends StatefulWidget {
  TFTextField({
    Key? key,
    this.title,
    required this.controller,
    this.focusNode,
    this.readOnly = false,
    this.autoFocus = false,
    this.obscureText = false,
    this.expand = false,
    this.enabled = true,
    this.showError = true,
    this.showDoneButton = true,
    this.onKeyboardDone,
    this.onTap,
    this.onChanged,
    this.onFocusChanged,
    this.hintText = "",
    this.prefix,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.inputFormatters,
    this.onEditingComplete,
    this.maxLines,
    this.validationTypes = const <TFValidationType>[],
    this.relatedController,
    this.regex,
    this.retypeInvalidMessage,
    this.style,
    this.autofillHints,
    this.prefixPadding = 10.0,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.regex) && regex == null) {
      throw ArgumentError("regex type and regex should both be set.");
    }
    if (validationTypes.contains(TFValidationType.requiredIfHas) && relatedController == null) {
      throw ArgumentError("requiredIfHas type and relatedController should both be set.");
    }
    if (validationTypes.contains(TFValidationType.retype) && relatedController == null) {
      throw ArgumentError("retype type and relatedController should both be set.");
    }
    if (validationTypes.contains(TFValidationType.retype) && retypeInvalidMessage == null) {
      throw ArgumentError("retype type and retypeInvalidMessage should both be set.");
    }
  }

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool autoFocus;
  final bool obscureText;
  final bool expand;
  final bool enabled;
  final bool showError;
  final bool showDoneButton;
  final Function()? onTap;
  final Function()? onKeyboardDone;
  final Function(String)? onChanged;
  final Function(bool)? onFocusChanged;
  final Function()? onEditingComplete;
  final String? title;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TFFieldStyle? style;
  final List<String>? autofillHints;
  final double prefixPadding;

  /// For validation
  final List<TFValidationType> validationTypes;

  /// For requiredIfHas type
  final TextEditingController? relatedController;

  /// For regex type
  final RegExp? regex;

  /// For retype field
  final String? retypeInvalidMessage;

  @override
  State<TFTextField> createState() => _TFTextFieldState();
}

class _TFTextFieldState extends State<TFTextField> {
  late FocusNode _focusNode;
  String _errorMessage = "";
  String _preVal = "";
  bool _hasFocus = false;

  List<TFValidationType> get _validationTypes => widget.validationTypes;
  String get _val => widget.controller.text.trim();
  String get _requiredErrorMessage => "This field is required";
  double get _height => widget.style?.height ?? _tffStyle.fieldStyle.height!;
  double get _radius => widget.style?.radius ?? _tffStyle.fieldStyle.radius!;
  double get _borderWidth => widget.style?.borderWidth ?? _tffStyle.fieldStyle.borderWidth!;
  EdgeInsets get _contentPadding => widget.style?.contentPadding ?? _tffStyle.fieldStyle.contentPadding!;
  TextStyle get _titleStyle => widget.style?.titleStyle ?? _tffStyle.fieldStyle.titleStyle ?? _tffStyle.titleStyle;
  TextStyle get _contentStyle => widget.style?.contentStyle ?? _tffStyle.fieldStyle.contentStyle!;
  TextStyle get _hintStyle => widget.style?.hintStyle ?? _tffStyle.fieldStyle.hintStyle!;
  Color get _borderColor => widget.style?.borderColor ?? _tffStyle.fieldStyle.borderColor!;
  Color get _focusBorderColor => widget.style?.focusBorderColor ?? _tffStyle.fieldStyle.focusBorderColor!;
  Color get _backgroundColor => widget.style?.backgroundColor ?? _tffStyle.fieldStyle.backgroundColor!;

  void _setErrorMessage({String val = ""}) {
    setState(() {
      _errorMessage = val;
    });
  }

  void _onTextChanged() {
    if (_val != _preVal) {
      _preVal = _val;
    } else {
      return;
    }

    if ((TFForm.of(context)?.widget.autoValidate ?? false) && _validationTypes.isNotEmpty) {
      final errorMessage = _validate();
      _setErrorMessage(val: errorMessage);
    }

    if (widget.onChanged != null) {
      widget.onChanged!(_val);
    }
  }

  String _validate() {
    final form = TFForm.of(context)!;

    if (_validationTypes.contains(TFValidationType.required)) {
      if (_val.isEmpty) {
        return _requiredErrorMessage;
      }
    } else if (_validationTypes.contains(TFValidationType.requiredIfHas)) {
      final relatedVal = widget.relatedController!.text;
      if (relatedVal.isNotEmpty && _val.isEmpty) {
        return _requiredErrorMessage;
      }
    }

    if (_needValidate(this)) {
      if (_validationTypes.contains(TFValidationType.emailAddress)) {
        if (!TFFormValidator.validateEmailAddress(_val)) {
          return form.widget.emailErrorMessage;
        }
      }
      if (_validationTypes.contains(TFValidationType.date)) {
        if (!TFFormValidator.validateDate(_val)) {
          return form.widget.dateErrorMessage;
        }
      }
      if (_validationTypes.contains(TFValidationType.password)) {
        if (!TFFormValidator.validatePassword(_val, form.widget.passwordPolicy)) {
          return form.widget.passwordErrorMessage;
        }
      }
      if (_validationTypes.contains(TFValidationType.retype)) {
        if (_val != widget.relatedController!.text) {
          return widget.retypeInvalidMessage ?? "";
        }
      }
      if (_validationTypes.contains(TFValidationType.simpleChars)) {
        if (!TFFormValidator.validateSimpleChars(_val)) {
          return form.widget.simpleCharsErrorMessage;
        }
      }
      if (_validationTypes.contains(TFValidationType.slugChars)) {
        if (!TFFormValidator.validateSlugChars(_val)) {
          return form.widget.slugCharsErrorMessage;
        }
      }
      if (_validationTypes.contains(TFValidationType.domainChars)) {
        if (!TFFormValidator.validateDomainChars(_val)) {
          return form.widget.domainCharsErrorMessage;
        }
      }
      if (_validationTypes.contains(TFValidationType.simpleSlugChars)) {
        if (!TFFormValidator.validateSimpleSlugChars(_val)) {
          return form.widget.simpleSlugCharsErrorMessage;
        }
      }
      if (_validationTypes.contains(TFValidationType.reallySimpleChars)) {
        if (!TFFormValidator.validateReallySimpleChars(_val)) {
          return form.widget.reallySimpleCharsErrorMessage;
        }
      }
      if (_validationTypes.contains(TFValidationType.href)) {
        if (!TFFormValidator.validateHref(_val)) {
          return form.widget.hrefErrorMessage;
        }
      }
      if (_validationTypes.contains(TFValidationType.integer)) {
        if (!TFFormValidator.validateInteger(_val)) {
          return form.widget.hrefErrorMessage;
        }
      }
      if (_validationTypes.contains(TFValidationType.phone)) {
        if (!TFFormValidator.validatePhone(_val)) {
          return form.widget.phoneErrorMessage;
        }
      }
    }

    return "";
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });

    // Add action bar for numeric keyboard in iOS
    if (Platform.isIOS && numericKeyboardTypes.contains(widget.keyboardType) && widget.showDoneButton) {
      if (_hasFocus) {
        TFKeyboardActionBar.showOverlay(context, onDone: widget.onKeyboardDone);
      } else {
        TFKeyboardActionBar.removeOverlay();
      }
    }

    if (widget.onFocusChanged != null) {
      widget.onFocusChanged!(_hasFocus);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_validationTypes.isNotEmpty) {
        TFForm.of(context)?._registerField(this);
      }
    });
    widget.controller.addListener(_onTextChanged);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void deactivate() {
    if (_validationTypes.isNotEmpty) {
      TFForm.of(context)?._unregisterField(this);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: _titleStyle,
          ),
          const SizedBox(height: 10),
        ],
        Container(
          width: double.infinity,
          height: widget.expand ? null : _height,
          padding: _contentPadding,
          decoration: _defaultDecoration,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: widget.expand ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              if (widget.prefix != null) widget.prefix!,
              if (widget.prefix != null) SizedBox(width: widget.prefixPadding),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  autofocus: widget.autoFocus,
                  autofillHints: widget.autofillHints,
                  readOnly: widget.readOnly,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onEditingComplete: widget.onEditingComplete,
                  onTap: widget.onTap,
                  inputFormatters: widget.inputFormatters,
                  textAlign: widget.textAlign,
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: widget.expand ? widget.maxLines : 1,
                  maxLength: widget.maxLength,
                  style: _contentStyle,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: (_height - 2 * _borderWidth - _contentStyle.fontSize!) / 2,
                    ),
                    hintText: widget.hintText,
                    hintStyle: _hintStyle,
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    counterText: "",
                  ),
                ),
              ),
              if (widget.suffix is! SizedBox) const SizedBox(width: 10),
              widget.suffix ?? _clearButton(),
            ],
          ),
        ),
        TFErrorText(
          error: _errorMessage,
          visible: widget.showError && _errorMessage.isNotEmpty,
        ),
      ],
    );
  }

  BoxDecoration get _defaultDecoration => BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          width: _borderWidth,
          color: _errorMessage.isNotEmpty
              ? Theme.of(context).colorScheme.error
              : _hasFocus
                  ? _focusBorderColor
                  : _borderColor,
        ),
      );

  Widget _clearButton() {
    if (widget.readOnly || !widget.enabled) return const SizedBox();
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, snapshot, child) {
        return Visibility(
          visible: snapshot.text.isNotEmpty,
          child: InkWell(
            onTap: widget.controller.clear,
            child: Icon(
              Icons.clear,
              size: 20,
              color: _contentStyle.color,
            ),
          ),
        );
      },
    );
  }
}
