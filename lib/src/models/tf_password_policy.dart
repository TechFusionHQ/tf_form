/// Password policy object is the set of rules for the password field in [TFForm] widget.
class TFFormPasswordPolicy {
  final int maxlength;
  final int minLength;
  final int? minUpper;
  final int? minLower;
  final int? minSpecial;
  final int minAlpha;
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
