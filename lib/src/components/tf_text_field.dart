part of 'tf_form.dart';

/// A single form field.
///
/// This widget maintains the current state of the form field, so that updates
/// and validation errors are visually reflected in the UI.
///
/// A [TFForm] ancestor is required. The [TFForm] simply makes it easier to
/// validate multiple fields at once.
class TFTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool autoFocus;
  final bool obscureText;
  final bool expand;
  final bool enabled;
  final Function()? onTap;
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

  /// For validation
  final List<TFValidationType> validationTypes;

  /// For requiredIfHas type
  final TextEditingController? relatedController;

  /// For confirmPassword type
  final TextEditingController? passwordController;

  /// For regex type
  final RegExp? regex;

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
    this.passwordController,
    this.regex,
    this.style,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.regex) && regex == null) {
      throw ArgumentError("regex type and regex should both be set.");
    }
    if (validationTypes.contains(TFValidationType.requiredIfHas) &&
        relatedController == null) {
      throw ArgumentError(
          "requiredIfHas type and relatedController should both be set.");
    }
    if (validationTypes.contains(TFValidationType.confirmPassword) &&
        passwordController == null) {
      throw ArgumentError(
          "confirmPassword type and passwordController should both be set.");
    }
  }

  @override
  State<TFTextField> createState() => _TFTextFieldState();
}

class _TFTextFieldState extends State<TFTextField> {
  late FocusNode _focusNode;
  String _errorMessage = "";
  String _preVal = "";
  bool _hasFocus = false;

  List<TFValidationType> get validationTypes => widget.validationTypes;

  String get val => widget.controller.text.trim();

  String get requiredErrorMessage => "This field is required";

  void _setErrorMessage({String val = ""}) {
    setState(() {
      _errorMessage = val;
    });
  }

  void _onTextChanged() {
    if (val != _preVal) {
      _preVal = val;
    } else {
      return;
    }

    if ((TFForm.of(context)?.widget.autoValidate ?? false) &&
        validationTypes.isNotEmpty) {
      final errorMessage = _validate();
      _setErrorMessage(val: errorMessage);
    }

    if (widget.onChanged != null) {
      widget.onChanged!(val);
    }
  }

  String _validate() {
    final form = TFForm.of(context)!;

    if (validationTypes.contains(TFValidationType.required)) {
      if (val.isEmpty) {
        return requiredErrorMessage;
      }
    } else if (validationTypes.contains(TFValidationType.requiredIfHas)) {
      final relatedVal = widget.relatedController!.text;
      if (relatedVal.isNotEmpty && val.isEmpty) {
        return requiredErrorMessage;
      }
    }

    if (_needValidate(this)) {
      if (validationTypes.contains(TFValidationType.emailAddress)) {
        if (!TFFormValidator.validateEmailAddress(val)) {
          return form.widget.emailErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.date)) {
        if (!TFFormValidator.validateDate(val)) {
          return form.widget.dateErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.password)) {
        if (!TFFormValidator.validatePassword(
            val, form.widget.passwordPolicy)) {
          return form.widget.passwordErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.confirmPassword)) {
        if (val != widget.passwordController!.text) {
          return form.widget.confirmPasswordErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.simpleChars)) {
        if (!TFFormValidator.validateSimpleChars(val)) {
          return form.widget.simpleCharsErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.slugChars)) {
        if (!TFFormValidator.validateSlugChars(val)) {
          return form.widget.slugCharsErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.domainChars)) {
        if (!TFFormValidator.validateDomainChars(val)) {
          return form.widget.domainCharsErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.simpleSlugChars)) {
        if (!TFFormValidator.validateSimpleSlugChars(val)) {
          return form.widget.simpleSlugCharsErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.reallySimpleChars)) {
        if (!TFFormValidator.validateReallySimpleChars(val)) {
          return form.widget.reallySimpleCharsErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.href)) {
        if (!TFFormValidator.validateHref(val)) {
          return form.widget.hrefErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.integer)) {
        if (!TFFormValidator.validateInteger(val)) {
          return form.widget.hrefErrorMessage;
        }
      }
      if (validationTypes.contains(TFValidationType.phone)) {
        if (!TFFormValidator.validatePhone(val)) {
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
    if (Platform.isIOS && numericKeyboardTypes.contains(widget.keyboardType)) {
      if (_hasFocus) {
        TFKeyboardActionBar.showOverlay(context);
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
      if (validationTypes.isNotEmpty) {
        TFForm.of(context)?._registerField(this);
      }
    });
    widget.controller.addListener(_onTextChanged);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void deactivate() {
    if (validationTypes.isNotEmpty) {
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
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: _tffStyle.titleStyle,
          ),
        if (widget.title != null) const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: widget.expand ? null : _height,
          padding: _contentPadding,
          decoration: defaultDecoration,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: widget.expand
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (widget.prefix != null) widget.prefix!,
              if (widget.prefix != null) const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  autofocus: widget.autoFocus,
                  readOnly: widget.readOnly,
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
              const SizedBox(width: 10),
              widget.suffix ?? clearButton(),
            ],
          ),
        ),
        TFErrorText(
          error: _errorMessage,
          visible: _errorMessage.isNotEmpty,
        ),
      ],
    );
  }

  BoxDecoration get defaultDecoration => BoxDecoration(
        color: _tffStyle.backgroundColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          width: _borderWidth,
          color: _errorMessage.isNotEmpty
              ? _tffStyle.errorColor
              : _hasFocus
                  ? _tffStyle.activeColor
                  : _borderColor,
        ),
      );

  Widget clearButton() {
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
              color: _contentStyle?.color,
            ),
          ),
        );
      },
    );
  }

  get _height => widget.style?.height ?? _tffStyle.fieldStyle.height;
  get _contentPadding => widget.style?.contentPadding ?? _tffStyle.fieldStyle.contentPadding;
  get _contentStyle => widget.style?.contentStyle ?? _tffStyle.fieldStyle.contentStyle;
  get _hintStyle => widget.style?.hintStyle ?? _tffStyle.fieldStyle.hintStyle;
  get _borderRadius => widget.style?.borderRadius ?? _tffStyle.fieldStyle.borderRadius;
  get _borderWidth => widget.style?.borderWidth ?? _tffStyle.fieldStyle.borderWidth;
  get _borderColor => widget.style?.borderColor ?? _tffStyle.fieldStyle.borderColor;
}
