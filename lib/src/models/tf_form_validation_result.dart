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

/// Validation result object that will be returned when calling [TFFormState.validate]
class TFFormValidationResult {
  TFFormValidationResult({
    this.errors = 0,
    this.errorMessages = const <String>[],
  });

  factory TFFormValidationResult.empty() => TFFormValidationResult();
  
  int errors;
  List<String> errorMessages;
}
