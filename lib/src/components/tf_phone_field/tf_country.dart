class TFCountry {
  final String name;
  final Map<String, String> nameTranslations;
  final String flag;
  final String code;
  final String dialCode;

  const TFCountry({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.nameTranslations,
  });

  String localizedName(String languageCode) {
    return nameTranslations[languageCode] ?? name;
  }
}


