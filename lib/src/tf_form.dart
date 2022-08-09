import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf_form/src/tf_form_models.dart';
import 'package:tf_form/src/tf_form_validator.dart';

/// An optional container for grouping together multiple [TFFormField] widgets
///
/// To obtain the [TFFormState], you may use [TFForm.of]
/// with a context whose ancestor is the [TFForm], or pass a [GlobalKey] to the
/// [TFForm] constructor and call [GlobalKey.currentState].
class TFForm extends StatefulWidget {
  /// The widget below this widget in the tree.
  /// This is the root of the widget hierarchy that contains this form.
  final Widget child;

  /// Used to enable/disable [TFFormField] auto validation and update its error text
  final bool autoValidate;

  /// Used to show or not show the error widget
  final bool visibleError;

  /// The policy for password text field type
  final TFFormPasswordPolicy passwordPolicy;

  /// The error message when required fields are invalid
  final String requiredErrorMessage;

  /// The error message when email fields are invalid
  final String emailErrorMessage;

  /// The error message when email name fields are invalid
  final String emailNameErrorMessage;

  /// The error message when date fields are invalid
  final String dateErrorMessage;

  /// The error message when password fields are invalid
  final String passwordErrorMessage;

  /// The error message when confirmPassword fields are invalid
  final String confirmPasswordErrorMessage;

  /// The error message when simpleChars fields are invalid
  final String simpleCharsErrorMessage;

  /// The error message when slugChars fields are invalid
  final String slugCharsErrorMessage;

  /// The error message when simpleSlugChars fields are invalid
  final String simpleSlugCharsErrorMessage;

  /// The error message when domainChars fields are invalid
  final String domainCharsErrorMessage;

  /// The error message when reallySimpleChars fields are invalid
  final String reallySimpleCharsErrorMessage;

  /// The error message when numeric fields are invalid
  final String numberErrorMessage;

  /// The error message when integer fields are invalid
  final String integerErrorMessage;

  /// The error message when url fields are invalid
  final String hrefErrorMessage;

  /// The error message when phone fields are invalid
  final String phoneErrorMessage;

  /// Constructor
  /// The [child] argument must not be null.
  const TFForm({
    Key? key,
    required this.child,
    this.autoValidate = true,
    this.visibleError = true,
    this.passwordPolicy = const TFFormPasswordPolicy(),
    this.requiredErrorMessage = 'Please enter all required fields',
    this.emailErrorMessage = 'Please check the format of your email address, it should read like ben@somewhere.com',
    this.emailNameErrorMessage =
        'Please check the format of your email address, it should read like "Joe Bloggs" &lt;joe@bloggs.com> or joe@bloggs.com',
    this.dateErrorMessage = 'Please enter valid date',
    this.passwordErrorMessage = 'Your password must be at least 6 characters and it must contain numbers and letters',
    this.confirmPasswordErrorMessage = 'Please confirm your password',
    this.simpleCharsErrorMessage = 'Please confirm your password',
    this.slugCharsErrorMessage = 'Please use only letters, numbers, underscores, dots, dashes and spaces',
    this.simpleSlugCharsErrorMessage =
        'Please use only letters, numbers, underscores, dashes. Please do not use underscores or dashes at the start and/or end',
    this.domainCharsErrorMessage = 'Please use only letters, numbers, dashes and dots. Please do not use dashes or dots at the start and/or end',
    this.reallySimpleCharsErrorMessage = 'Please use only letters and numbers, no punctuation, dots, spaces, etc',
    this.numberErrorMessage = 'Please enter only numeric digits',
    this.integerErrorMessage = 'Please enter only integer',
    this.hrefErrorMessage = 'Please enter valid URL',
    this.phoneErrorMessage = 'Please enter valid phone number',
  }) : super(key: key);

  /// Returns the closest [TFFormState] which encloses the given context.
  /// Typical usage is as follows:
  /// ```dart
  /// _TFFormState form = TFForm.of(context);
  /// ```
  static TFFormState? of(BuildContext context) {
    final _TFFormScope? scope = context.dependOnInheritedWidgetOfExactType<_TFFormScope>();
    return scope?._formState;
  }

  @override
  State<TFForm> createState() => TFFormState();
}

/// State associated with a [TFForm] widget.
///
/// A [TFFormState] object can be used to [validate] every
/// [TFFormField] that is a descendant of the associated [Form].
///
/// Typically obtained via [TFForm.of].
class TFFormState extends State<TFForm> {
  final _fieldMap = <TFValidationType, List<_TFFormFieldState>>{};
  List<String> _errorMessages = [];

  void _register(_TFFormFieldState field) {
    for (var type in field.validationTypes) {
      if (_fieldMap.containsKey(type)) {
        _fieldMap[type]!.add(field);
      } else {
        _fieldMap[type] = [field];
      }
    }
  }

  void _unregister(_TFFormFieldState field) {
    for (var type in field.validationTypes) {
      if (_fieldMap.containsKey(type)) {
        _fieldMap[type]!.remove(field);
      }
    }
  }

  int _validateRequiredFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.required)) {
      for (var field in _fieldMap[TFValidationType.required]!) {
        if (TFFormValidator.validateRequired(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: field.requiredErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validateEmailAddressFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.emailAddress)) return errors;
    for (var field in _fieldMap[TFValidationType.emailAddress]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validateEmailAddress(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.emailErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validateDateFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.date)) return errors;
    for (var field in _fieldMap[TFValidationType.date]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validateDate(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.dateErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validatePasswordFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.password)) return errors;
    for (var field in _fieldMap[TFValidationType.password]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validatePassword(
          field.val,
          widget.passwordPolicy,
        )) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.passwordErrorMessage);
        }
      }
    }

    return errors;
  }

  int _validateConfirmPasswordFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.confirmPassword)) return errors;
    for (var field in _fieldMap[TFValidationType.confirmPassword]!) {
      if (_needValidate(field)) {
        if (field.val == field.widget.passwordController!.text) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.confirmPasswordErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validateSimpleCharsFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.simpleChars)) return errors;
    for (var field in _fieldMap[TFValidationType.simpleChars]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validateSimpleChars(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.simpleCharsErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validateSlugCharsFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.simpleChars)) return errors;
    for (var field in _fieldMap[TFValidationType.simpleChars]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validateSlugChars(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.slugCharsErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validateSimpleSlugCharsFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.simpleSlugChars)) return errors;
    for (var field in _fieldMap[TFValidationType.simpleSlugChars]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validateSimpleSlugChars(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.simpleSlugCharsErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validateDomainCharsFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.domainChars)) return errors;
    for (var field in _fieldMap[TFValidationType.domainChars]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validateDomainChars(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.domainCharsErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validateReallySimpleCharsFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.reallySimpleChars)) {
      return errors;
    }
    for (var field in _fieldMap[TFValidationType.reallySimpleChars]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validateReallySimpleChars(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.reallySimpleCharsErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validateHrefFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.href)) return errors;
    for (var field in _fieldMap[TFValidationType.href]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validateHref(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.hrefErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validateIntegerFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.integer)) return errors;
    for (var field in _fieldMap[TFValidationType.integer]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validateInteger(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.integerErrorMessage);
        }
      }
    }
    return errors;
  }

  int _validateRegexFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.regex)) return errors;
    for (var field in _fieldMap[TFValidationType.regex]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validateRegex(field.val, field.widget.regex!)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage();
        }
      }
    }
    return errors;
  }

  int _validatePhoneFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFValidationType.phone)) return errors;
    for (var field in _fieldMap[TFValidationType.phone]!) {
      if (_needValidate(field)) {
        if (TFFormValidator.validatePhone(field.val)) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: widget.phoneErrorMessage);
        }
      }
    }
    return errors;
  }

  /// Validates every [TFFormField] that is a descendant of this [TFForm], and
  /// returns [TFFormValidationResult].
  ///
  /// The form will rebuild.
  TFFormValidationResult validate() {
    int errors = 0;
    List<String> errorMessages = [];

    final resultRequired = _validateRequiredFields();
    if (resultRequired > 0) {
      errors += resultRequired;
      errorMessages.add(widget.requiredErrorMessage);
    } else {
      final resultEmailAddress = _validateEmailAddressFields();
      if (resultEmailAddress > 0) {
        errors += resultEmailAddress;
        errorMessages.add(widget.emailErrorMessage);
      }

      final resultDate = _validateDateFields();
      if (resultDate > 0) {
        errors += resultDate;
        errorMessages.add(widget.dateErrorMessage);
      }

      final resultPassword = _validatePasswordFields();
      if (resultPassword > 0) {
        errors += resultPassword;
        errorMessages.add(widget.passwordErrorMessage);
      }

      final resultConfirmPassword = _validateConfirmPasswordFields();
      if (resultConfirmPassword > 0) {
        errors += resultConfirmPassword;
        errorMessages.add(widget.confirmPasswordErrorMessage);
      }

      final resultSimpleChar = _validateSimpleCharsFields();
      if (resultSimpleChar > 0) {
        errors += resultSimpleChar;
        errorMessages.add(widget.simpleCharsErrorMessage);
      }

      final resultSlugChar = _validateSlugCharsFields();
      if (resultSlugChar > 0) {
        errors += resultSlugChar;
        errorMessages.add(widget.slugCharsErrorMessage);
      }

      final resultSimpleSlugChar = _validateSimpleSlugCharsFields();
      if (resultSimpleSlugChar > 0) {
        errors += resultSimpleSlugChar;
        errorMessages.add(widget.simpleSlugCharsErrorMessage);
      }

      final resultReallySimpleChar = _validateReallySimpleCharsFields();
      if (resultReallySimpleChar > 0) {
        errors += resultReallySimpleChar;
        errorMessages.add(widget.reallySimpleCharsErrorMessage);
      }

      final resultDomainChar = _validateDomainCharsFields();
      if (resultDomainChar > 0) {
        errors += resultDomainChar;
        errorMessages.add(widget.domainCharsErrorMessage);
      }

      final resultHref = _validateHrefFields();
      if (resultHref > 0) {
        errors += resultHref;
        errorMessages.add(widget.hrefErrorMessage);
      }

      final resultInteger = _validateIntegerFields();
      if (resultInteger > 0) {
        errors += resultInteger;
        errorMessages.add(widget.integerErrorMessage);
      }

      final resultPhone = _validatePhoneFields();
      if (resultPhone > 0) {
        errors += resultPhone;
        errorMessages.add(widget.phoneErrorMessage);
      }
    }

    setState(() {
      _errorMessages = errorMessages;
    });

    return TFFormValidationResult(
      errors: errors,
      errorMessages: errorMessages,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _TFFormScope(
      formState: this,
      child: Column(
        children: [
          Visibility(
            visible: widget.visibleError && _errorMessages.isNotEmpty,
            child: _buildError(),
          ),
          widget.child,
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        border: Border.all(width: 1, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_errorMessages.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == _errorMessages.length - 1 ? 0 : 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 18,
                  color: Colors.red,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    _errorMessages[index],
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Check if a [TFFormField] needs validation
///
/// returns [true] if this [TFFormField] needs validation.
bool _needValidate(_TFFormFieldState field) {
  if (field.validationTypes.contains(TFValidationType.required)) {
    return true;
  }
  if (field.validationTypes.contains(TFValidationType.requiredIf)) {
    if (field.val.isNotEmpty) {
      return true;
    }
  }
  if (field.validationTypes.contains(TFValidationType.requiredIfHas)) {
    final relatedInputVal = field.widget.relatedController!.text.trim();
    if (relatedInputVal.isNotEmpty) {
      return true;
    }
  }
  return false;
}

class _TFFormScope extends InheritedWidget {
  const _TFFormScope({
    Key? key,
    required Widget child,
    required TFFormState formState,
  })  : _formState = formState,
        super(key: key, child: child);

  final TFFormState _formState;

  /// The [TFForm] associated with this widget.
  TFForm get form => _formState.widget;

  @override
  bool updateShouldNotify(_TFFormScope old) => false;
}

/// A single form field.
///
/// This widget maintains the current state of the form field, so that updates
/// and validation errors are visually reflected in the UI.
///
/// A [TFForm] ancestor is required. The [TFForm] simply makes it easier to
/// validate multiple fields at once.
class TFFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool readOnly;
  final bool autoFocus;
  final bool obscureText;
  final bool expand;
  final FocusNode? focusNode;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final String label;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  /// For styling
  final double? height;
  final double? borderRadius;
  final EdgeInsets? insetPadding;
  final TextStyle? labelStyle;
  final TextStyle? contentStyle;
  final TextStyle? hintStyle;
  final Color borderColor;
  final Color focusBorderColor;
  final Color errorBorderColor;
  final Color backgroundColor;
  final BoxDecoration? decoration;

  /// For validation
  final List<TFValidationType> validationTypes;

  /// For requiredIfHas type
  final TextEditingController? relatedController;

  /// For confirmPassword type
  final TextEditingController? passwordController;

  /// For regex type
  final RegExp? regex;

  TFFormField({
    Key? key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.autoFocus = false,
    this.obscureText = false,
    this.expand = false,
    this.onTap,
    this.onChanged,
    this.focusNode,
    this.hintText = "",
    this.height,
    this.keyboardType,
    this.prefix,
    this.textInputAction,
    this.suffix,
    this.textAlign,
    this.maxLength,
    this.inputFormatters,
    this.onEditingComplete,
    this.maxLines,
    this.decoration,
    this.borderRadius,
    this.insetPadding,
    this.labelStyle,
    this.contentStyle,
    this.hintStyle,
    this.borderColor = const Color(0x1F000000),
    this.focusBorderColor = const Color(0xFF0084FF),
    this.errorBorderColor = const Color(0xFFE82C2B),
    this.backgroundColor = const Color(0xFFFFFFFF),
    required this.validationTypes,
    this.relatedController,
    this.passwordController,
    this.regex,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.regex) && regex == null) {
      throw ArgumentError("regex type and regex should both be set.");
    }
    if (validationTypes.contains(TFValidationType.requiredIfHas) && relatedController == null) {
      throw ArgumentError("requiredIfHas type and relatedController should both be set.");
    }
    if (validationTypes.contains(TFValidationType.confirmPassword) && passwordController == null) {
      throw ArgumentError("confirmPassword type and passwordController should both be set.");
    }
  }

  @override
  State<TFFormField> createState() => _TFFormFieldState();
}

class _TFFormFieldState extends State<TFFormField> {
  late FocusNode _focusNode;
  String _errorMessage = "";
  bool _hasFocus = false;

  List<TFValidationType> get validationTypes => widget.validationTypes;

  String get val => widget.controller.text.trim();

  String get requiredErrorMessage => "Please enter a ${widget.label.toLowerCase()}";

  void _setErrorMessage({String val = ""}) {
    setState(() {
      _errorMessage = val;
    });
  }

  void _onChanged(String val) {
    final form = TFForm.of(context);
    if (form == null) return;

    if (form.widget.autoValidate) {
      String errorMessage = "";
      if (validationTypes.contains(TFValidationType.required)) {
        if (!TFFormValidator.validateRequired(val)) {
          errorMessage = requiredErrorMessage;
        }
      }
      if (errorMessage.isEmpty && _needValidate(this)) {
        errorMessage = _validate();
      }
      _setErrorMessage(val: errorMessage);
    }

    if (widget.onChanged != null) {
      widget.onChanged!(val);
    }
  }

  String _validate() {
    final form = TFForm.of(context)!;

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
      if (!TFFormValidator.validatePassword(val, form.widget.passwordPolicy)) {
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
    return "";
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TFForm.of(context)?._register(this);
    });

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void deactivate() {
    TFForm.of(context)?._unregister(this);
    super.deactivate();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText(),
        const SizedBox(height: 8),
        _buildFieldContainer(),
        const SizedBox(height: 8),
        _buildErrorText(),
      ],
    );
  }

  Widget _buildLabelText() {
    return Text(
      widget.label,
      style: widget.labelStyle ?? const TextStyle(fontSize: 16, color: Color(0xFF595858)),
    );
  }

  Widget _buildFieldContainer() {
    return Container(
      width: double.infinity,
      height: widget.expand ? null : widget.height ?? 48,
      padding: widget.insetPadding ?? defaultInsetPadding,
      decoration: widget.decoration ?? defaultDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: widget.expand ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
              keyboardType: widget.keyboardType ?? TextInputType.text,
              textInputAction: widget.textInputAction,
              onEditingComplete: widget.onEditingComplete,
              onTap: widget.onTap,
              onChanged: _onChanged,
              inputFormatters: widget.inputFormatters,
              textAlign: widget.textAlign ?? TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              maxLines: widget.expand ? widget.maxLines : 1,
              maxLength: widget.maxLength,
              style: widget.contentStyle,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: widget.hintStyle,
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
          widget.suffix ?? clearButton,
        ],
      ),
    );
  }

  Widget _buildErrorText() {
    return Visibility(
      visible: _errorMessage.isNotEmpty,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error,
            size: 16,
            color: widget.errorBorderColor,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: widget.errorBorderColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets get defaultInsetPadding => const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
        bottom: 5,
      );

  BoxDecoration get defaultDecoration => BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
        border: Border.all(
          width: 1,
          color: _errorMessage.isNotEmpty
              ? widget.errorBorderColor
              : _hasFocus
                  ? widget.focusBorderColor
                  : widget.borderColor,
        ),
      );

  Widget get clearButton => ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller,
        builder: (context, snapshot, child) {
          return Visibility(
            visible: snapshot.text.isNotEmpty,
            child: InkWell(
              onTap: () {
                widget.controller.clear();
                _onChanged(val);
              },
              child: const Icon(
                Icons.clear,
                color: Colors.grey,
              ),
            ),
          );
        },
      );
}
