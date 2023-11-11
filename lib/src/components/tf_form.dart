// Copyright (c) 2022 TechFusion Ltd (https://www.techfusion.dev).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tf_form/src/constants/constants.dart';
import 'package:tf_form/src/models/models.dart';
import 'package:tf_form/src/utils/tf_form_validator.dart';
import 'package:tf_form/src/components/tf_keyboard_actionbar.dart';
import 'dart:async';
import 'package:tf_form/src/components/tf_phone_field/tf_country_picker_dialog.dart';
import 'package:tf_form/src/components/tf_phone_field/tf_phone_number.dart';
import 'package:tf_form/src/components/tf_phone_field/countries.dart';

part 'tf_checkbox_group.dart';

part 'tf_dropdown_field.dart';

part 'tf_dropdown_field_2.dart';

part 'tf_date_field.dart';

part 'tf_error_text.dart';

part 'tf_radio_group.dart';

part 'tf_text_field.dart';

part 'tf_recaptcha_field.dart';

part './tf_phone_field/tf_phone_field.dart';

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

  /// The error message when retype fields are invalid
  final String retypeErrorMessage;

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
    this.dateErrorMessage = 'Please enter a valid date',
    this.passwordErrorMessage = 'Your password must be at least 6 characters and it must contain numbers and letters',
    this.retypeErrorMessage = 'Please confirm your field',
    this.simpleCharsErrorMessage = 'Please use only letters, numbers, underscores, dots, dashes and spaces',
    this.slugCharsErrorMessage = 'Please use only letters, numbers, underscores, dots, dashes and spaces',
    this.simpleSlugCharsErrorMessage =
        'Please use only letters, numbers, underscores, dashes. Please do not use underscores or dashes at the start and/or end',
    this.domainCharsErrorMessage =
        'Please use only letters, numbers, dashes and dots. Please do not use dashes or dots at the start and/or end',
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

  static void initStyle({
    TextStyle? titleStyle,
    TextStyle? errorStyle,
    TFFieldStyle? fieldStyle,
    TFGroupStyle? groupStyle,
  }) {
    _tffStyle = _tffStyle.copyWith(
      titleStyle: titleStyle,
      errorStyle: errorStyle,
      fieldStyle: _tffStyle.fieldStyle.copyWith(fieldStyle: fieldStyle),
      groupStyle: _tffStyle.groupStyle.copyWith(groupStyle: groupStyle),
    );
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
  final _radioGroupMap = <TFValidationType, List<_TFRadioGroupState>>{};

  List<String> _errorMessages = [];

  void _registerField(_TFTextFieldState field) {
    for (var type in field._validationTypes) {
      if (_fieldMap.containsKey(type)) {
        _fieldMap[type]!.add(field);
      } else {
        _fieldMap[type] = [field];
      }
    }
  }

  void _registerCheckboxGroup(_TFCheckboxGroupState group) {
    for (var type in group._validationTypes) {
      if (_checkboxGroupMap.containsKey(type)) {
        _checkboxGroupMap[type]!.add(group);
      } else {
        _checkboxGroupMap[type] = [group];
      }
    }
  }

  void _registerRadioGroup(_TFRadioGroupState group) {
    for (var type in group._validationTypes) {
      if (_radioGroupMap.containsKey(type)) {
        _radioGroupMap[type]!.add(group);
      } else {
        _radioGroupMap[type] = [group];
      }
    }
  }

  void _unregisterField(_TFTextFieldState field) {
    for (var type in field._validationTypes) {
      if (_fieldMap.containsKey(type)) {
        _fieldMap[type]!.remove(field);
      }
    }
  }

  void _unregisterCheckboxGroup(_TFCheckboxGroupState group) {
    for (var type in group._validationTypes) {
      if (_checkboxGroupMap.containsKey(type)) {
        _checkboxGroupMap[type]!.remove(group);
      }
    }
  }

  void _unregisterRadioGroup(_TFRadioGroupState group) {
    for (var type in group._validationTypes) {
      if (_radioGroupMap.containsKey(type)) {
        _radioGroupMap[type]!.remove(group);
      }
    }
  }

  int _validateRequiredFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.required)) {
      for (var field in _fieldMap[TFValidationType.required]!) {
        if (field._val.isNotEmpty) {
          field._setErrorMessage();
        } else {
          errors++;
          field._setErrorMessage(val: field._requiredErrorMessage);
        }
      }
    }
    if (_checkboxGroupMap.containsKey(TFValidationType.required)) {
      for (var group in _checkboxGroupMap[TFValidationType.required]!) {
        if (group._selectedValues.isNotEmpty) {
          group._setValid(true);
        } else {
          errors++;
          group._setValid(false);
        }
      }
    }
    if (_radioGroupMap.containsKey(TFValidationType.required)) {
      for (var group in _radioGroupMap[TFValidationType.required]!) {
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
        if (relatedVal.isNotEmpty && field._val.isEmpty) {
          errors++;
          field._setErrorMessage(val: field._requiredErrorMessage);
        } else {
          field._setErrorMessage();
        }
      }
    }
    if (_checkboxGroupMap.containsKey(TFValidationType.requiredIfHas)) {
      for (var group in _checkboxGroupMap[TFValidationType.requiredIfHas]!) {
        final relatedVal = group.widget.relatedController!.text;
        if (relatedVal.isNotEmpty && group._selectedValues.isEmpty) {
          errors++;
          group._setValid(false);
        } else {
          group._setValid(true);
        }
      }
    }
    if (_radioGroupMap.containsKey(TFValidationType.requiredIfHas)) {
      for (var group in _radioGroupMap[TFValidationType.requiredIfHas]!) {
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
          if (TFFormValidator.validateEmailAddress(field._val)) {
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
          if (TFFormValidator.validateDate(field._val)) {
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
            field._val,
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

  int _validateRetypeFields() {
    int errors = 0;
    if (_fieldMap.containsKey(TFValidationType.retype)) {
      for (var field in _fieldMap[TFValidationType.retype]!) {
        if (_needValidate(field)) {
          if (field._val == field.widget.relatedController!.text) {
            field._setErrorMessage();
          } else {
            errors++;
            field._setErrorMessage(val: widget.retypeErrorMessage);
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
          if (TFFormValidator.validateSimpleChars(field._val)) {
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
          if (TFFormValidator.validateSlugChars(field._val)) {
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
          if (TFFormValidator.validateSimpleSlugChars(field._val)) {
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
          if (TFFormValidator.validateDomainChars(field._val)) {
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
          if (TFFormValidator.validateReallySimpleChars(field._val)) {
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
          if (TFFormValidator.validateHref(field._val)) {
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
          if (TFFormValidator.validateInteger(field._val)) {
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
          if (TFFormValidator.validateRegex(field._val, field.widget.regex!)) {
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
          if (TFFormValidator.validatePhone(field._val)) {
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

      final errorRetype = _validateRetypeFields();
      if (errorRetype > 0) {
        errors += errorRetype;
        errorMessages.add(widget.retypeErrorMessage);
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
        mainAxisSize: MainAxisSize.min,
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
        border: Border.all(width: 1, color: Theme.of(context).colorScheme.error),
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
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    _errorMessages[index],
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
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
  if (field._validationTypes.contains(TFValidationType.required)) {
    return true;
  }
  if (field._validationTypes.contains(TFValidationType.requiredIf)) {
    if (field._val.isNotEmpty) {
      return true;
    }
  }
  if (field._validationTypes.contains(TFValidationType.requiredIfHas)) {
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

TFFormStyle _tffStyle = const TFFormStyle(
  fieldStyle: TFFieldStyle(
    height: 50,
    radius: 10,
    borderWidth: 1,
    borderColor: Colors.grey,
    focusBorderColor: Colors.lightBlueAccent,
    backgroundColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
    contentStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1),
    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1),
  ),
  groupStyle: TFGroupStyle(
    itemTitleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1),
    unselectedColor: Colors.black87,
  ),
);
