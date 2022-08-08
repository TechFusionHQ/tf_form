class TFFormValidationResult {
  int errors;
  List<String> errorMessages;

  TFFormValidationResult({
    this.errors = 0,
    this.errorMessages = const <String>[],
  });

  factory TFFormValidationResult.empty() => TFFormValidationResult();
}

class TFFormPasswordPolicy {
  final int maxlength;
  final int minLength;
  final int? minUpper;
  final int? minLower;
  final int? minSpecial;
  final int minAlpha;
  final int minNumberic;
  final List<String> badWords;
  final int badSequenceLength;
  final bool noQwertySequences;
  final bool noSequential;
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
    this.badSequenceLength = 6,
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
