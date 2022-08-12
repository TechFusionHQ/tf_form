// Copyright (c) 2022 TechFusion Ltd (https://www.techfusion.dev).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf_form/src/tf_form_models.dart';
import 'package:tf_form/src/tf_form_validator.dart';
import 'package:tf_form/src/tf_keyboard_actionbar.dart';

/// An optional container for grouping together multiple [TFTextField] widgets
///
/// To obtain the [TFFormState], you may use [TFForm.of]
/// with a context whose ancestor is the [TFForm], or pass a [GlobalKey] to the
/// [TFForm] constructor and call [GlobalKey.currentState].
class TFForm extends StatefulWidget {
  /// The widget below this widget in the tree.
  /// This is the root of the widget hierarchy that contains this form.
  final Widget child;

  /// Used to enable/disable [TFTextField] auto validation and update its error text
  final bool autoValidate;

  /// Used to show or not show the error widget
  final bool visibleError;

  /// The policy for password text field type
  final TFFormPasswordPolicy passwordPolicy;

  /// The error message when required fields are invalid
  final String requiredErrorMessage;

  /// The error message when email fields are invalid
  final String emailErrorMessage;

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

  /// The style
  final TFFormStyle style;

  /// Constructor
  /// The [child] argument must not be null.
  const TFForm({
    Key? key,
    required this.child,
    this.autoValidate = true,
    this.visibleError = true,
    this.passwordPolicy = const TFFormPasswordPolicy(),
    this.style = const TFFormStyle(),
    this.requiredErrorMessage = 'Please enter all required fields',
    this.emailErrorMessage = 'Please check the format of your email address, it should read like ben@somewhere.com',
    this.dateErrorMessage = 'Please enter a valid date',
    this.passwordErrorMessage = 'Your password must be at least 6 characters and it must contain numbers and letters',
    this.confirmPasswordErrorMessage = 'Please confirm your password',
    this.simpleCharsErrorMessage = 'Please use only letters, numbers, underscores, dots, dashes and spaces',
    this.slugCharsErrorMessage = 'Please use only letters, numbers, underscores, dots, dashes and spaces',
    this.simpleSlugCharsErrorMessage = 'Please use only letters, numbers, underscores, dashes. Please do not use underscores or dashes at the start and/or end',
    this.domainCharsErrorMessage = 'Please use only letters, numbers, dashes and dots. Please do not use dashes or dots at the start and/or end',
    this.reallySimpleCharsErrorMessage = 'Please use only letters and numbers, no punctuation, dots, spaces, etc',
    this.numberErrorMessage = 'Please enter only numeric digits',
    this.integerErrorMessage = 'Please enter only integer',
    this.hrefErrorMessage = 'Please enter a valid URL',
    this.phoneErrorMessage = 'Please enter a valid phone number',
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
/// [TFTextField] that is a descendant of the associated [Form].
///
/// Typically obtained via [TFForm.of].
class TFFormState extends State<TFForm> {
  final _fieldMap = <TFValidationType, List<_TFTextFieldState>>{};
  final _checkboxGroupMap = <TFValidationType, List<_TFCheckboxGroupState>>{};
  final _raidoGroupMap = <TFValidationType, List<_TFRadioGroupState>>{};

  List<String> _errorMessages = [];

  void _registerField(_TFTextFieldState field) {
    for (var type in field.validationTypes) {
      if (_fieldMap.containsKey(type)) {
        _fieldMap[type]!.add(field);
      } else {
        _fieldMap[type] = [field];
      }
    }
  }

  void _registerCheckboxGroup(_TFCheckboxGroupState group) {
    for (var type in group.validationTypes) {
      if (_checkboxGroupMap.containsKey(type)) {
        _checkboxGroupMap[type]!.add(group);
      } else {
        _checkboxGroupMap[type] = [group];
      }
    }
  }

  void _registerRadioGroup(_TFRadioGroupState group) {
    for (var type in group.validationTypes) {
      if (_raidoGroupMap.containsKey(type)) {
        _raidoGroupMap[type]!.add(group);
      } else {
        _raidoGroupMap[type] = [group];
      }
    }
  }

  void _unregisterField(_TFTextFieldState field) {
    for (var type in field.validationTypes) {
      if (_fieldMap.containsKey(type)) {
        _fieldMap[type]!.remove(field);
      }
    }
  }

  void _unregisterCheckboxGroup(_TFCheckboxGroupState group) {
    for (var type in group.validationTypes) {
      if (_checkboxGroupMap.containsKey(type)) {
        _checkboxGroupMap[type]!.remove(group);
      }
    }
  }

  void _unregisterRadioGroup(_TFRadioGroupState group) {
    for (var type in group.validationTypes) {
      if (_raidoGroupMap.containsKey(type)) {
        _raidoGroupMap[type]!.remove(group);
      }
    }
  }

  int _validateRequiredFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.required)) {
      for (var field in _fieldMap[TFValidationType.required]!) {
        if (field.val.isNotEmpty) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: field.requiredErrorMessage);
        }
      }
    }
    if (_checkboxGroupMap.containsKey(TFValidationType.required)) {
      for (var group in _checkboxGroupMap[TFValidationType.required]!) {
        if (group._checkedItemIndexes.isNotEmpty) {
          group._setValid(true);
        } else {
          errors++;
          group._setValid(false);
        }
      }
    }
    if (_raidoGroupMap.containsKey(TFValidationType.required)) {
      for (var group in _raidoGroupMap[TFValidationType.required]!) {
        if (group._groupValue != null) {
          group._setValid(true);
        } else {
          errors++;
          group._setValid(false);
        }
      }
    }
    return errors;
  }

  int _validateRequiredIfHasFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.requiredIfHas)) {
      for (var field in _fieldMap[TFValidationType.requiredIfHas]!) {
        final relatedVal = field.widget.relatedController!.text;
        if (relatedVal.isNotEmpty && field.val.isEmpty) {
          errors++;
          field._setErrorMessage(val: field.requiredErrorMessage);
        } else {
          field._setErrorMessage();
        }
      }
    }
    if (_checkboxGroupMap.containsKey(TFValidationType.requiredIfHas)) {
      for (var group in _checkboxGroupMap[TFValidationType.requiredIfHas]!) {
        final relatedVal = group.widget.relatedController!.text;
        if (relatedVal.isNotEmpty && group._checkedItemIndexes.isEmpty) {
          errors++;
          group._setValid(false);
        } else {
          group._setValid(true);
        }
      }
    }
    if (_raidoGroupMap.containsKey(TFValidationType.requiredIfHas)) {
      for (var group in _raidoGroupMap[TFValidationType.requiredIfHas]!) {
        final relatedVal = group.widget.relatedController!.text;
        if (relatedVal.isNotEmpty && group._groupValue == null) {
          errors++;
          group._setValid(false);
        } else {
          group._setValid(true);
        }
      }
    }
    return errors;
  }

  int _validateEmailAddressFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.emailAddress)) {
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
    }

    return errors;
  }

  int _validateDateFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.date)) {
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
    }

    return errors;
  }

  int _validatePasswordFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.password)) {
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
    }

    return errors;
  }

  int _validateConfirmPasswordFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.confirmPassword)) {
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
    }

    return errors;
  }

  int _validateSimpleCharsFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.simpleChars)) {
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
    }

    return errors;
  }

  int _validateSlugCharsFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.simpleChars)) {
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
    }

    return errors;
  }

  int _validateSimpleSlugCharsFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.simpleSlugChars)) {
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
    }

    return errors;
  }

  int _validateDomainCharsFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.domainChars)) {
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
    }

    return errors;
  }

  int _validateReallySimpleCharsFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.reallySimpleChars)) {
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
    }

    return errors;
  }

  int _validateHrefFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.href)) {
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
    }

    return errors;
  }

  int _validateIntegerFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.integer)) {
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
    }

    return errors;
  }

  int _validateRegexFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.regex)) {
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
    }

    return errors;
  }

  int _validatePhoneFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.phone)) {
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
    }

    return errors;
  }

  /// Validates every [TFTextField] that is a descendant of this [TFForm], and
  /// returns [TFFormValidationResult].
  ///
  /// The form will rebuild.
  TFFormValidationResult validate() {
    int errors = 0;
    List<String> errorMessages = [];

    final errorRequired = _validateRequiredFields();
    if (errorRequired > 0) {
      errors += errorRequired;
      errorMessages.add(widget.requiredErrorMessage);
    } else {
      final errorRequiredIfHas = _validateRequiredIfHasFields();
      if (errorRequiredIfHas > 0) {
        errors += errorRequiredIfHas;
        errorMessages.add(widget.requiredErrorMessage);
      }

      final errorEmailAddress = _validateEmailAddressFields();
      if (errorEmailAddress > 0) {
        errors += errorEmailAddress;
        errorMessages.add(widget.emailErrorMessage);
      }

      final errorDate = _validateDateFields();
      if (errorDate > 0) {
        errors += errorDate;
        errorMessages.add(widget.dateErrorMessage);
      }

      final errorPassword = _validatePasswordFields();
      if (errorPassword > 0) {
        errors += errorPassword;
        errorMessages.add(widget.passwordErrorMessage);
      }

      final errorConfirmPassword = _validateConfirmPasswordFields();
      if (errorConfirmPassword > 0) {
        errors += errorConfirmPassword;
        errorMessages.add(widget.confirmPasswordErrorMessage);
      }

      final errorSimpleChar = _validateSimpleCharsFields();
      if (errorSimpleChar > 0) {
        errors += errorSimpleChar;
        errorMessages.add(widget.simpleCharsErrorMessage);
      }

      final errorSlugChar = _validateSlugCharsFields();
      if (errorSlugChar > 0) {
        errors += errorSlugChar;
        errorMessages.add(widget.slugCharsErrorMessage);
      }

      final errorSimpleSlugChar = _validateSimpleSlugCharsFields();
      if (errorSimpleSlugChar > 0) {
        errors += errorSimpleSlugChar;
        errorMessages.add(widget.simpleSlugCharsErrorMessage);
      }

      final errorReallySimpleChar = _validateReallySimpleCharsFields();
      if (errorReallySimpleChar > 0) {
        errors += errorReallySimpleChar;
        errorMessages.add(widget.reallySimpleCharsErrorMessage);
      }

      final errorDomainChar = _validateDomainCharsFields();
      if (errorDomainChar > 0) {
        errors += errorDomainChar;
        errorMessages.add(widget.domainCharsErrorMessage);
      }

      final errorHref = _validateHrefFields();
      if (errorHref > 0) {
        errors += errorHref;
        errorMessages.add(widget.hrefErrorMessage);
      }

      final errorInteger = _validateIntegerFields();
      if (errorInteger > 0) {
        errors += errorInteger;
        errorMessages.add(widget.integerErrorMessage);
      }

      final errorPhone = _validatePhoneFields();
      if (errorPhone > 0) {
        errors += errorPhone;
        errorMessages.add(widget.phoneErrorMessage);
      }

      final errorRegex = _validateRegexFields();
      if (errorRegex > 0) {
        errors += errorRegex;
        errorMessages.add("");
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
        border: Border.all(width: 1, color: widget.style.errorColor),
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
                Icon(
                  Icons.error_outline,
                  size: 18,
                  color: widget.style.errorColor,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    _errorMessages[index],
                    style: TextStyle(color: widget.style.errorColor),
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

/// Check if a [TFTextField] needs validation
///
/// returns [true] if this [TFTextField] needs validation.
bool _needValidate(_TFTextFieldState field) {
  if (field.validationTypes.contains(TFValidationType.required)) {
    return true;
  }
  if (field.validationTypes.contains(TFValidationType.requiredIf)) {
    if (field.val.isNotEmpty) {
      return true;
    }
  }
  if (field.validationTypes.contains(TFValidationType.requiredIfHas)) {
    final relatedVal = field.widget.relatedController!.text.trim();
    if (relatedVal.isNotEmpty) {
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
class TFTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool autoFocus;
  final bool obscureText;
  final bool expand;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(bool)? onFocusChanged;
  final Function()? onEditingComplete;
  final String title;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;

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
    required this.title,
    required this.controller,
    this.focusNode,
    this.readOnly = false,
    this.autoFocus = false,
    this.obscureText = false,
    this.expand = false,
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

    if ((TFForm.of(context)?.widget.autoValidate ?? false) && validationTypes.isNotEmpty) {
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
        Text(
          widget.title,
          style: TFFormStyle.of(context).titleStyle,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: widget.expand ? null : TFFormStyle.of(context).fieldStyle.height,
          padding: TFFormStyle.of(context).fieldStyle.contentPadding,
          decoration: defaultDecoration,
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
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onEditingComplete: widget.onEditingComplete,
                  onTap: widget.onTap,
                  inputFormatters: widget.inputFormatters,
                  textAlign: widget.textAlign,
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: widget.expand ? widget.maxLines : 1,
                  maxLength: widget.maxLength,
                  style: TFFormStyle.of(context).fieldStyle.contentStyle,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TFFormStyle.of(context).fieldStyle.hintStyle,
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
        ),
        TFErrorText(
          error: _errorMessage,
          visible: _errorMessage.isNotEmpty,
        ),
      ],
    );
  }

  BoxDecoration get defaultDecoration => BoxDecoration(
        color: TFFormStyle.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(
          TFFormStyle.of(context).fieldStyle.borderRadius,
        ),
        border: Border.all(
          width: TFFormStyle.of(context).fieldStyle.borderWidth,
          color: _errorMessage.isNotEmpty
              ? TFFormStyle.of(context).errorColor
              : _hasFocus
                  ? TFFormStyle.of(context).activeColor
                  : TFFormStyle.of(context).fieldStyle.borderColor,
        ),
      );

  Widget get clearButton => ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller,
        builder: (context, snapshot, child) {
          return Visibility(
            visible: snapshot.text.isNotEmpty,
            child: InkWell(
              onTap: widget.controller.clear,
              child: const Icon(
                Icons.clear,
                color: Colors.grey,
              ),
            ),
          );
        },
      );
}

/// [TFDropdownField] widget allows the user to pick a value from a dropdown list
class TFDropdownField extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? initialItem;
  final TextEditingController controller;
  final List<TFValidationType> validationTypes;
  final TextEditingController? relatedController;

  TFDropdownField({
    Key? key,
    required this.title,
    required this.items,
    required this.controller,
    this.initialItem,
    this.validationTypes = const <TFValidationType>[],
    this.relatedController,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.requiredIfHas) && relatedController == null) {
      throw ArgumentError("requiredIfHas type and relatedController should both be set.");
    }
  }

  @override
  State<TFDropdownField> createState() => _TFDropdownFieldState();
}

class _TFDropdownFieldState extends State<TFDropdownField> {
  final LayerLink __dropdownLink = LayerLink();
  OverlayEntry? _dropdownOverlay;

  void _showDropdown() {
    _dropdownOverlay = _buildDropListOverlay();
    Overlay.of(context)?.insert(_dropdownOverlay!);
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialItem != null) {
      widget.controller.text = widget.initialItem!;
    }
  }

  @override
  void dispose() {
    _dropdownOverlay?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: __dropdownLink,
      child: TFTextField(
        title: widget.title,
        controller: widget.controller,
        validationTypes: widget.validationTypes,
        relatedController: widget.relatedController,
        readOnly: true,
        suffix: const Icon(
          Icons.arrow_drop_down,
          color: Colors.grey,
        ),
        onTap: () {
          if (_dropdownOverlay == null) {
            _showDropdown();
          } else {
            _hideDropdown();
          }
        },
        onFocusChanged: (hasFocus) {
          if (!hasFocus) _hideDropdown();
        },
      ),
    );
  }

  OverlayEntry _buildDropListOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final activeColor = TFFormStyle.of(context).activeColor;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: __dropdownLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 2,
            color: TFFormStyle.of(context).backgroundColor,
            child: Column(
              children: List.generate(widget.items.length, (index) {
                final item = widget.items[index];
                final isSelected = widget.controller.text == item;
                return ListTile(
                  title: Text(item),
                  selected: isSelected,
                  selectedColor: Colors.white,
                  selectedTileColor: activeColor,
                  trailing: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 18,
                        )
                      : null,
                  onTap: () {
                    widget.controller.text = item;
                    _hideDropdown();
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// [TFDateField] widget allows the user to pick a DateTime from an input field
class TFDateField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<TFValidationType> validationTypes;
  final TextEditingController? relatedController;

  TFDateField({
    Key? key,
    required this.title,
    required this.controller,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.validationTypes = const <TFValidationType>[],
    this.relatedController,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.requiredIfHas) && relatedController == null) {
      throw ArgumentError("requiredIfHas type and relatedController should both be set.");
    }
  }

  @override
  State<TFDateField> createState() => _TFDateFieldState();
}

class _TFDateFieldState extends State<TFDateField> {
  void _showDatePicker() async {
    final now = DateTime.now();
    const range = Duration(days: 365 * 40);
    final result = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? now,
      firstDate: widget.firstDate ?? now.subtract(range),
      lastDate: widget.lastDate ?? now.add(range),
    );
    if (result != null) {
      widget.controller.text = TFFormValidator.getDateFormat().format(result);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      widget.controller.text = TFFormValidator.getDateFormat().format(
        widget.initialDate!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TFTextField(
      title: widget.title,
      hintText: TFFormValidator.getDateFormat().pattern,
      controller: widget.controller,
      validationTypes: widget.validationTypes,
      relatedController: widget.relatedController,
      readOnly: true,
      suffix: const Icon(
        Icons.arrow_drop_down,
        color: Colors.grey,
      ),
      onTap: _showDatePicker,
    );
  }
}

/// [TFCheckboxGroup] widget allows user to select multiple items.
/// The checkbox is displayed before the item name,
/// which you can check/uncheck to make/remove the selection.
class TFCheckboxGroup extends StatefulWidget {
  final String title;
  final List<TFCheckboxItem> items;
  final Function(List<int>) onChanged;
  final List<TFValidationType> validationTypes;
  final TextEditingController? relatedController;

  TFCheckboxGroup({
    Key? key,
    required this.title,
    required this.items,
    required this.onChanged,
    this.validationTypes = const <TFValidationType>[],
    this.relatedController,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.requiredIfHas) && relatedController == null) {
      throw ArgumentError("requiredIfHas type and relatedController should both be set.");
    }
  }

  @override
  State<TFCheckboxGroup> createState() => _TFCheckboxGroupState();
}

class _TFCheckboxGroupState extends State<TFCheckboxGroup> {
  List<int> _checkedItemIndexes = [];
  bool _isValid = true;

  List<TFValidationType> get validationTypes => widget.validationTypes;

  void _setValid(bool val) {
    setState(() {
      _isValid = val;
    });
  }

  void _onItemChanged(int index, bool value) {
    final checkedItemIndexes = List.of(_checkedItemIndexes);
    if (value) {
      checkedItemIndexes.add(index);
    } else {
      checkedItemIndexes.remove(index);
    }
    checkedItemIndexes.sort();
    widget.onChanged(checkedItemIndexes);
    setState(() {
      _checkedItemIndexes = List.of(checkedItemIndexes);
    });

    // for autoValidate
    if ((TFForm.of(context)?.widget.autoValidate ?? false) && validationTypes.isNotEmpty) {
      final isValid = _validate();
      _setValid(isValid);
    }
  }

  bool _validate() {
    if (validationTypes.contains(TFValidationType.required)) {
      if (_checkedItemIndexes.isEmpty) {
        return false;
      }
    } else if (validationTypes.contains(TFValidationType.requiredIfHas)) {
      final relatedVal = widget.relatedController!.text;
      if (relatedVal.isNotEmpty && _checkedItemIndexes.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (validationTypes.isNotEmpty) {
        TFForm.of(context)?._registerCheckboxGroup(this);
      }
    });
  }

  @override
  void deactivate() {
    if (validationTypes.isNotEmpty) {
      TFForm.of(context)?._unregisterCheckboxGroup(this);
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TFFormStyle.of(context).titleStyle,
        ),
        TFErrorText(
          error: "This field is required",
          visible: !_isValid,
        ),
        const SizedBox(height: 8),
        ...List.generate(widget.items.length, (index) {
          return _buildCheckboxTile(widget.items[index], index);
        }),
      ],
    );
  }

  Widget _buildCheckboxTile(TFCheckboxItem item, int index) {
    return CheckboxListTile(
      title: Text(
        item.title,
        style: TFFormStyle.of(context).groupStyle.itemTitleStyle.copyWith(
              color: _isValid ? null : TFFormStyle.of(context).errorColor,
            ),
      ),
      value: _checkedItemIndexes.contains(index),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: TFFormStyle.of(context).activeColor,
      contentPadding: EdgeInsets.zero,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      side: BorderSide(
        width: 1.5,
        color: _isValid ? TFFormStyle.of(context).groupStyle.unselectedColor : TFFormStyle.of(context).errorColor,
      ),
      onChanged: (value) {
        _onItemChanged(index, value ?? false);
      },
    );
  }
}

/// [TFRadioGroup] widget allows user to select one option from multiple selections.
class TFRadioGroup<T> extends StatefulWidget {
  final String title;
  final List<TFRadioItem<T>> items;
  final T? groupValue;
  final Function(T?) onChanged;
  final List<TFValidationType> validationTypes;
  final TextEditingController? relatedController;

  TFRadioGroup({
    Key? key,
    required this.title,
    required this.items,
    required this.onChanged,
    this.groupValue,
    this.validationTypes = const <TFValidationType>[],
    this.relatedController,
  }) : super(key: key) {
    if (validationTypes.contains(TFValidationType.requiredIfHas) && relatedController == null) {
      throw ArgumentError("requiredIfHas type and relatedController should both be set.");
    }
  }

  @override
  State<TFRadioGroup<T>> createState() => _TFRadioGroupState<T>();
}

class _TFRadioGroupState<T> extends State<TFRadioGroup<T>> {
  T? _groupValue;
  bool _isValid = true;

  List<TFValidationType> get validationTypes => widget.validationTypes;

  void _setValid(bool val) {
    setState(() {
      _isValid = val;
    });
  }

  void _onItemChanged(T? val) {
    widget.onChanged(val);
    setState(() {
      _groupValue = val;
    });

    // for autoValidate
    if ((TFForm.of(context)?.widget.autoValidate ?? false) && validationTypes.isNotEmpty) {
      final isValid = _validate();
      _setValid(isValid);
    }
  }

  bool _validate() {
    if (validationTypes.contains(TFValidationType.required)) {
      if (_groupValue == null) {
        return false;
      }
    } else if (validationTypes.contains(TFValidationType.requiredIfHas)) {
      final relatedVal = widget.relatedController!.text;
      if (relatedVal.isNotEmpty && _groupValue == null) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (validationTypes.isNotEmpty) {
        TFForm.of(context)?._registerRadioGroup(this);
      }
    });
    _groupValue = widget.groupValue;
  }

  @override
  void deactivate() {
    if (validationTypes.isNotEmpty) {
      TFForm.of(context)?._unregisterRadioGroup(this);
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: _isValid ? TFFormStyle.of(context).groupStyle.unselectedColor : TFFormStyle.of(context).errorColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TFFormStyle.of(context).titleStyle,
          ),
          TFErrorText(
            error: "This field is required",
            visible: !_isValid,
          ),
          const SizedBox(height: 8),
          ...List.generate(widget.items.length, (index) {
            return _buildRadioTile(widget.items[index], index);
          }),
        ],
      ),
    );
  }

  Widget _buildRadioTile(TFRadioItem<T> item, int index) {
    return ListTile(
      title: Text(
        item.title,
        style: TFFormStyle.of(context).groupStyle.itemTitleStyle.copyWith(
              color: _isValid ? null : TFFormStyle.of(context).errorColor,
            ),
      ),
      contentPadding: EdgeInsets.zero,
      leading: Radio<T>(
        value: item.value,
        groupValue: _groupValue,
        onChanged: _onItemChanged,
        activeColor: TFFormStyle.of(context).activeColor,
      ),
    );
  }
}

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
              color: TFFormStyle.of(context).errorColor,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                error,
                style: TextStyle(
                  color: TFFormStyle.of(context).errorColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
