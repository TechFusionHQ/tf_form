// Copyright (c) 2022 TechFusion Ltd (https://www.techfusion.dev).

import 'package:flutter/material.dart';
import 'package:tf_form/tf_form.dart';

/// Used to configure the validation type of [TFTextField] and [TFForm] widgets.
enum TFValidationType {
  required,
  requiredIf,
  requiredIfHas,
  emailAddress,
  date,
  password,
  confirmPassword,
  simpleChars,
  slugChars,
  simpleSlugChars,
  domainChars,
  reallySimpleChars,
  href,
  integer,
  regex,
  phone,
}

extension TFValidationTypeExt on TFValidationType {
  bool get isUnique => [
        TFValidationType.emailAddress,
        TFValidationType.date,
        TFValidationType.password,
        TFValidationType.confirmPassword,
        TFValidationType.simpleChars,
        TFValidationType.slugChars,
        TFValidationType.simpleSlugChars,
        TFValidationType.domainChars,
        TFValidationType.reallySimpleChars,
        TFValidationType.reallySimpleChars,
        TFValidationType.href,
        TFValidationType.integer,
        TFValidationType.phone,
      ].contains(this);
}

/// Validation result object that will be returned when calling [TFFormState.validate]
class TFFormValidationResult {
  /// Number of errors
  int errors;

  /// List of error messages
  List<String> errorMessages;

  TFFormValidationResult({
    this.errors = 0,
    this.errorMessages = const <String>[],
  });

  factory TFFormValidationResult.empty() => TFFormValidationResult();
}

/// Password policy object is the set of rules for the password field in [TFForm] widget.
class TFFormPasswordPolicy {
  /// Maximum length
  final int maxlength;

  /// Minimum length
  final int minLength;

  /// Minimum number of uppercase characters
  final int? minUpper;

  /// Minimum number of lowercase characters
  final int? minLower;

  /// Minimum number of special characters
  final int? minSpecial;

  /// Minimum number of alphabet characters
  final int minAlpha;

  /// Minimum number of digit characters
  final int minNumeric;

  /// List of words not allowed in password
  final List<String> badWords;

  /// Minimum number of sequential characters
  final int badSequenceLength;

  /// Multiple sequential characters are not allowed
  final bool noQwertySequences;

  /// Sequential characters are not allowed
  final bool noSequential;

  /// Custom rule
  final RegExp? custom;

  const TFFormPasswordPolicy({
    this.maxlength = 9223372036854775807,
    this.minLength = 6,
    this.minUpper = 0,
    this.minLower = 0,
    this.minSpecial = 0,
    this.minAlpha = 1,
    this.minNumeric = 1,
    this.badWords = const <String>[],
    this.badSequenceLength = 0,
    this.noQwertySequences = false,
    this.noSequential = false,
    this.custom,
  });

  Map<String, dynamic> toMap() {
    return {
      'maxlength': maxlength,
      'minLength': minLength,
      'minUpper': minUpper,
      'minLower': minLower,
      'minSpecial': minSpecial,
      'minAlpha': minAlpha,
      'minNumeric': minNumeric,
      'badWords': badWords,
      'badSequenceLength': badSequenceLength,
      'noQwertySequences': noQwertySequences,
      'noSequential': noSequential,
    };
  }
}

/// Checkbox item object is used for [TFCheckboxGroup]
class TFCheckboxItem {
  final String title;
  bool isChecked;

  TFCheckboxItem({
    required this.title,
    this.isChecked = false,
  });
}

/// Radio item object is used for [TFRadioGroup]
class TFRadioItem<T> {
  final String title;
  final T value;

  TFRadioItem({
    required this.title,
    required this.value,
  });
}

/// TFForm style object is used for styling
class TFFormStyle {
  /// The color is used for background color
  final Color backgroundColor;

  /// The color is used when the user interacts
  final Color activeColor;

  /// The color is used when form is related to an error
  final Color errorColor;

  /// The title of field / group widgets
  final TextStyle? titleStyle;

  /// The style of field widgets
  final TFFieldStyle fieldStyle;

  /// The style of checkbox/raido group widgets
  final TFGroupStyle groupStyle;

  const TFFormStyle({
    this.backgroundColor = Colors.white,
    this.activeColor = const Color(0xFF0084FF),
    this.errorColor = const Color(0xFFE82C2B),
    this.titleStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    this.fieldStyle = const TFFieldStyle(),
    this.groupStyle = const TFGroupStyle(),
  });

  static TFFormStyle of(BuildContext context) {
    return TFForm.of(context)?.widget.style ?? const TFFormStyle();
  }
}

/// The style of field widgets
class TFFieldStyle {
  final double height;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final EdgeInsets contentPadding;
  final TextStyle? contentStyle;
  final TextStyle? hintStyle;

  const TFFieldStyle({
    this.height = 48,
    this.borderRadius = 10,
    this.borderWidth = 1,
    this.borderColor = const Color(0x1F000000),
    this.contentPadding = const EdgeInsets.only(
      left: 10,
      right: 10,
      top: 5,
      bottom: 5,
    ),
    this.contentStyle,
    this.hintStyle,
  });
}

/// The style of checkbox/raido group widgets
class TFGroupStyle {
  final TextStyle itemTitleStyle;
  final Color unselectedColor;

  const TFGroupStyle({
    this.itemTitleStyle = const TextStyle(fontSize: 16),
    this.unselectedColor = Colors.black,
  });
}
