/// Used to configure the validation type of [TFFormField] and [TFForm] widgets.
enum TFValidationType {
  required,
  requiredIf,
  requiredIfHas,
  emailAddress,
  emailName,
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
  final int minNumberic;

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
    this.minNumberic = 1,
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
      'minNumeric': minNumberic,
      'badWords': badWords,
      'badSequenceLength': badSequenceLength,
      'noQwertySequences': noQwertySequences,
      'noSequential': noSequential,
    };
  }
}
