import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf_form/src/tf_form_models.dart';
import 'package:tf_form/src/tf_form_validator.dart';

enum TFTextFieldType {
  required,
  requiredIf,
  requiredIfHas,
  emailAddress,
  emailName,
  date,
  password,
  confirmPassword,
  simpleChar,
  slugChar,
  simpleSlugChar,
  domainChar,
  reallySimpleChar,
  href,
  number,
  interger,
  regex,
  phone,
}

class TFForm extends StatefulWidget {
  /// The widget below this widget in the tree.
  /// This is the root of the widget hierarchy that contains this form.
  final Widget child;

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

  const TFForm({
    Key? key,
    required this.child,
    this.passwordPolicy = const TFFormPasswordPolicy(),
    this.requiredErrorMessage = 'Please enter all required fields',
    this.emailErrorMessage =
        'Please check the format of your email address, it should read like ben@somewhere.com',
    this.emailNameErrorMessage =
        'Please check the format of your email address, it should read like "Joe Bloggs" &lt;joe@bloggs.com> or joe@bloggs.com',
    this.dateErrorMessage = 'Please enter valid date',
    this.passwordErrorMessage =
        'Your password must be at least 6 characters and it must contain numbers and letters',
    this.confirmPasswordErrorMessage = 'Please confirm your password',
    this.simpleCharsErrorMessage = 'Please confirm your password',
    this.slugCharsErrorMessage =
        'Please use only letters, numbers, underscores, dots, dashes and spaces',
    this.simpleSlugCharsErrorMessage =
        'Please use only letters, numbers, underscores, dashes. Please do not use underscores or dashes at the start and/or end',
    this.domainCharsErrorMessage =
        'Please use only letters, numbers, dashes and dots. Please do not use dashes or dots at the start and/or end',
    this.reallySimpleCharsErrorMessage =
        'Please use only letters and numbers, no punctuation, dots, spaces, etc',
    this.numberErrorMessage = 'Please enter only numeric digits',
    this.integerErrorMessage = 'Please enter only integer',
    this.hrefErrorMessage = 'Please enter valid website address',
    this.phoneErrorMessage = 'Please enter valid phone number',
  }) : super(key: key);

  /// Returns the closest [TFFormState] which encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// _TFFormState form = TFForm.of(context);
  /// ```
  static TFFormState? of(BuildContext context) {
    final _TFFormScope? scope =
        context.dependOnInheritedWidgetOfExactType<_TFFormScope>();
    return scope?._formState;
  }

  @override
  State<TFForm> createState() => TFFormState();
}

class TFFormState extends State<TFForm> {
  final _fieldMap = <TFTextFieldType, List<_TFTextFieldState>>{};
  List<String> _errorMessages = [];

  void _register(_TFTextFieldState field) {
    for (var type in field.types) {
      if (_fieldMap.containsKey(type)) {
        _fieldMap[type]!.add(field);
      } else {
        _fieldMap[type] = [field];
      }
    }
  }

  void _unregister(_TFTextFieldState field) {
    for (var type in field.types) {
      if (_fieldMap.containsKey(type)) {
        _fieldMap[type]!.remove(field);
      }
    }
  }

  bool _shouldCheckValue(_TFTextFieldState field) {
    if (field.types.contains(TFTextFieldType.required)) {
      return true;
    }
    if (field.types.contains(TFTextFieldType.requiredIf)) {
      if (field.val.isNotEmpty) {
        return true;
      }
    }
    if (field.types.contains(TFTextFieldType.requiredIfHas)) {
      final relatedInputVal = field.widget.relatedController!.text.trim();
      if (relatedInputVal.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  int _checkRequiredFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFTextFieldType.required)) {
      for (var field in _fieldMap[TFTextFieldType.required]!) {
        if (TFFormValidator.validateRequired(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.requiredErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkEmailAddressFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.emailAddress)) return errors;
    for (var field in _fieldMap[TFTextFieldType.emailAddress]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateEmailAddress(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.emailErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkEmailNameFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.emailName)) return errors;
    for (var field in _fieldMap[TFTextFieldType.emailName]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateEmailName(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.emailNameErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkDateFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.date)) return errors;
    for (var field in _fieldMap[TFTextFieldType.date]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateDate(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.dateErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkPasswordFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.password)) return errors;
    for (var field in _fieldMap[TFTextFieldType.password]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validatePassword(
          field.val,
          widget.passwordPolicy,
        )) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.passwordErrorMessage);
        }
      }
    }

    return errors;
  }

  int _checkConfirmPasswordFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.confirmPassword)) return errors;
    for (var field in _fieldMap[TFTextFieldType.confirmPassword]!) {
      if (_shouldCheckValue(field)) {
        if (field.val == field.widget.passwordController!.text) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.confirmPasswordErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkSimpleCharFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.simpleChar)) return errors;
    for (var field in _fieldMap[TFTextFieldType.simpleChar]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateSimpleChar(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.simpleCharsErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkSlugCharFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.simpleChar)) return errors;
    for (var field in _fieldMap[TFTextFieldType.simpleChar]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateSlugChar(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.slugCharsErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkSimpleSlugCharFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.simpleSlugChar)) return errors;
    for (var field in _fieldMap[TFTextFieldType.simpleSlugChar]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateSimpleSlugChar(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.simpleSlugCharsErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkDomainCharFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.domainChar)) return errors;
    for (var field in _fieldMap[TFTextFieldType.domainChar]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateDomainChar(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.domainCharsErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkReallySimpleCharFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.reallySimpleChar)) return errors;
    for (var field in _fieldMap[TFTextFieldType.reallySimpleChar]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateReallySimpleChar(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.reallySimpleCharsErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkHrefFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.href)) return errors;
    for (var field in _fieldMap[TFTextFieldType.href]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateHref(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.hrefErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkNumberFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.number)) return errors;
    for (var field in _fieldMap[TFTextFieldType.number]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateNumber(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.numberErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkIntegerFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.interger)) return errors;
    for (var field in _fieldMap[TFTextFieldType.interger]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateInteger(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.integerErrorMessage);
        }
      }
    }
    return errors;
  }

  int _checkRegexFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.regex)) return errors;
    for (var field in _fieldMap[TFTextFieldType.regex]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validateRegex(
          field.val,
          field.widget.regex!,
        )) {
          field._onValid();
        } else {
          errors++;
          field._onInValid("");
        }
      }
    }
    return errors;
  }

  int _checkPhoneFields() {
    int errors = 0;
    if (!_fieldMap.containsKey(TFTextFieldType.phone)) return errors;
    for (var field in _fieldMap[TFTextFieldType.phone]!) {
      if (_shouldCheckValue(field)) {
        if (TFFormValidator.validatePhone(field.val)) {
          field._onValid();
        } else {
          errors++;
          field._onInValid(widget.phoneErrorMessage);
        }
      }
    }
    return errors;
  }

  TFFormValidationResult validate() {
    int errors = 0;
    List<String> errorMessages = [];

    final resultRequired = _checkRequiredFields();
    if (resultRequired > 0) {
      errors += resultRequired;
      errorMessages.add(widget.requiredErrorMessage);
    } else {
      final resultEmailAddress = _checkEmailAddressFields();
      if (resultEmailAddress > 0) {
        errors += resultEmailAddress;
        errorMessages.add(widget.emailErrorMessage);
      }

      final resultEmailName = _checkEmailNameFields();
      if (resultEmailName > 0) {
        errors += resultEmailName;
        errorMessages.add(widget.emailNameErrorMessage);
      }

      final resultDate = _checkDateFields();
      if (resultDate > 0) {
        errors += resultDate;
        errorMessages.add(widget.dateErrorMessage);
      }

      final resultPassword = _checkPasswordFields();
      if (resultPassword > 0) {
        errors += resultPassword;
        errorMessages.add(widget.passwordErrorMessage);
      }

      final resultConfirmPassword = _checkConfirmPasswordFields();
      if (resultConfirmPassword > 0) {
        errors += resultConfirmPassword;
        errorMessages.add(widget.confirmPasswordErrorMessage);
      }

      final resultSimpleChar = _checkSimpleCharFields();
      if (resultSimpleChar > 0) {
        errors += resultSimpleChar;
        errorMessages.add(widget.simpleCharsErrorMessage);
      }

      final resultSlugChar = _checkSlugCharFields();
      if (resultSlugChar > 0) {
        errors += resultSlugChar;
        errorMessages.add(widget.slugCharsErrorMessage);
      }

      final resultSimpleSlugChar = _checkSimpleSlugCharFields();
      if (resultSimpleSlugChar > 0) {
        errors += resultSimpleSlugChar;
        errorMessages.add(widget.simpleSlugCharsErrorMessage);
      }

      final resultReallySimpleChar = _checkReallySimpleCharFields();
      if (resultReallySimpleChar > 0) {
        errors += resultReallySimpleChar;
        errorMessages.add(widget.reallySimpleCharsErrorMessage);
      }

      final resultDomainChar = _checkDomainCharFields();
      if (resultDomainChar > 0) {
        errors += resultDomainChar;
        errorMessages.add(widget.domainCharsErrorMessage);
      }

      final resultHref = _checkHrefFields();
      if (resultHref > 0) {
        errors += resultHref;
        errorMessages.add(widget.hrefErrorMessage);
      }

      final resultNumber = _checkNumberFields();
      if (resultNumber > 0) {
        errors += resultNumber;
        errorMessages.add(widget.numberErrorMessage);
      }

      final resultInteger = _checkIntegerFields();
      if (resultInteger > 0) {
        errors += resultInteger;
        errorMessages.add(widget.integerErrorMessage);
      }

      final resultPhone = _checkPhoneFields();
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
          _buildError(),
          widget.child,
        ],
      ),
    );
  }

  Widget _buildError() {
    return Visibility(
      visible: _errorMessages.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          border: Border.all(width: 1, color: Colors.red.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_errorMessages.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _errorMessages.length - 1 ? 0 : 5,
              ),
              child: Text(
                "- ${_errorMessages[index]}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TFFormScope extends InheritedWidget {
  const _TFFormScope({
    Key? key,
    required Widget child,
    required TFFormState formState,
  })  : _formState = formState,
        super(key: key, child: child);

  final TFFormState _formState;

  /// The [Form] associated with this widget.
  TFForm get form => _formState.widget;

  @override
  bool updateShouldNotify(_TFFormScope old) => false;
}

class TFTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final bool autoFocus;
  final bool obscureText;
  final bool expand;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final String? hintText;
  final double? height;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefix;
  final Widget? suffix;
  final TextAlign? textAlign;
  final int? maxLength;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final BoxDecoration? decoration;

  /// For validation (same as attr in html)
  final List<TFTextFieldType> types;

  /// For requiredIfHas type;
  final TextEditingController? relatedController;

  /// For confirmPassword type;
  final TextEditingController? passwordController;

  /// For regex type;
  final RegExp? regex;

  TFTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.autoFocus = false,
    this.obscureText = false,
    this.expand = false,
    this.onTap,
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
    required this.types,
    this.relatedController,
    this.passwordController,
    this.regex,
  }) : super(key: key) {
    if (types.contains(TFTextFieldType.regex) && regex == null) {
      throw ArgumentError("regex type and regex should both be set.");
    }
    if (types.contains(TFTextFieldType.requiredIfHas) &&
        relatedController == null) {
      throw ArgumentError(
          "requiredIfHas type and relatedController should both be set.");
    }
    if (types.contains(TFTextFieldType.confirmPassword) &&
        passwordController == null) {
      throw ArgumentError(
          "confirmPassword type and passwordController should both be set.");
    }
  }

  @override
  State<TFTextField> createState() => _TFTextFieldState();
}

class _TFTextFieldState extends State<TFTextField> {
  List<TFTextFieldType> get types => widget.types;
  String get val => widget.controller.text.trim();

  String _errorMessage = "";

  void _onValid() {
    setState(() {
      _errorMessage = "";
    });
  }

  void _onInValid(String errorMessage) {
    setState(() {
      _errorMessage = errorMessage;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TFForm.of(context)?._register(this);
    });
  }

  @override
  void deactivate() {
    TFForm.of(context)?._unregister(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        Container(
          height: widget.expand ? null : widget.height ?? 54,
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 14,
            right: 14,
            top: 7,
            bottom: 7,
          ),
          decoration: widget.decoration ?? defaultDecoration(),
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
                  controller: widget.controller,
                  keyboardType: widget.keyboardType ?? TextInputType.text,
                  autofocus: widget.autoFocus,
                  readOnly: widget.readOnly,
                  textInputAction:
                      widget.textInputAction ?? TextInputAction.next,
                  onEditingComplete: widget.onEditingComplete,
                  onTap: widget.onTap,
                  inputFormatters: widget.inputFormatters,
                  textAlign: widget.textAlign ?? TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: widget.expand ? widget.maxLines : 1,
                  obscureText: widget.obscureText,
                  maxLength: widget.maxLength,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
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
              widget.suffix ?? clearTextButton(),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration defaultDecoration() => BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: _errorMessage.isNotEmpty
              ? Colors.red
              : Theme.of(context).dividerColor,
        ),
      );

  Widget clearTextButton() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, snapshot, child) {
        return Visibility(
          visible: snapshot.text.isNotEmpty,
          child: InkWell(
            onTap: () => widget.controller.clear(),
            child: const Icon(
              Icons.clear,
              size: 20,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
