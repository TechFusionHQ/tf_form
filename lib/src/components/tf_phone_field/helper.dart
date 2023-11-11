import 'package:tf_form/tf_form.dart';

bool isNumeric(String s) => s.isNotEmpty && int.tryParse(s.replaceAll("+", "")) != null;

String removeDiacritics(String str) {
  var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]);
  }

  return str;
}

extension CountryExtensions on List<TFCountry> {
  List<TFCountry> filter(String search) {
    search = removeDiacritics(search.toLowerCase());
    return where(
      (country) => isNumeric(search) || search.startsWith("+")
          ? country.dialCode.contains(search)
          : removeDiacritics(country.name.replaceAll("+", "").toLowerCase()).contains(search) ||
              country.nameTranslations.values
                  .any((element) => removeDiacritics(element.toLowerCase()).contains(search)),
    ).toList();
  }
}
