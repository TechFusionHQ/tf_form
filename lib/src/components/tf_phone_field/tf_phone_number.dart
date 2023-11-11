import 'package:tf_form/src/models/models.dart';

class TFPhoneNumber {
  TFCountry country;
  String number;

  TFPhoneNumber({
    required this.country,
    required this.number,
  });

  String get formattedNumber {
    String cleanNumber = number;
    if (cleanNumber.startsWith(country.dialCode)) {
      cleanNumber = cleanNumber.replaceFirst(RegExp("^${country.dialCode}"), "");
    }
    return "+${country.dialCode}$cleanNumber";
  }
}
