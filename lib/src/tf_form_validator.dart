import 'package:intl/intl.dart';
import 'package:tf_form/src/tf_form_models.dart';

class TFFormValidator {
  static final RegExp emailRegex = RegExp(
      r'^(?:[a-z0-9!#$%&"*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&"*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])');
  static final RegExp emailNameRegex = RegExp(
      r'^(?:"?([^"]*)"?\s)?(?:<?(?:[a-z0-9!#$%&"*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&"*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])>?)');
  static final RegExp phoneRegex =
      RegExp(r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
  static final RegExp simpleCharRegex = RegExp(r'^[a-zA-Z0-9_\.\ -]+$');
  static final RegExp domainCharRegex =
      RegExp(r'^[a-z0-9s]+(?:[-.][a-z0-9s]+)*$');
  static final RegExp slugCharRegex =
      RegExp(r'^[a-zA-Z0-9\s]+(?:[-_.][a-zA-Z0-9\s]+)*$');
  static final RegExp simpleSlugCharRegex =
      RegExp(r'^[a-zA-Z0-9\s]+(?:[-][a-zA-Z0-9\s]+)*$');
  static final RegExp reallySimpleCharRegex = RegExp(r'^[a-zA-Z0-9]+$');
  static final RegExp lowerCharRegex = RegExp(r'[a-z]');
  static final RegExp upperCharRegex = RegExp(r'[A-Z]');
  static final RegExp alphaCharRegex = RegExp(r'[a-zA-Z]');
  static final RegExp numericCharRegex = RegExp(r'[0-9]');
  static final RegExp specialCharRegex = RegExp(r'[\W_]');
  static final RegExp hrefRegex = RegExp(r'^[a-zA-Z0-9_/%:/.\-\+]+$');
  static final RegExp sequentialRegex = RegExp(r'([\S\s])\1');

  /////////////////////////////////////////////////////////////////
  static bool validateRequired(String val) {
    return val.isNotEmpty;
  }

  static bool validateEmailAddress(String val) {
    return val.isNotEmpty && emailRegex.hasMatch(val);
  }

  static bool validateEmailName(String val) {
    return val.isNotEmpty && emailRegex.hasMatch(val);
  }

  static bool validateDate(String val) {
    final dateFormat = DateFormat("dd-MM-yyyy");

    try {
      dateFormat.parse(val);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool validatePassword(String val, TFFormPasswordPolicy policy) {
    final regexMap = {
      "Upper": upperCharRegex,
      "Lower": lowerCharRegex,
      "Alpha": alphaCharRegex,
      "Digit": numericCharRegex,
      "Special": specialCharRegex,
    };
    // enforce min/max length
    if (val.length < policy.minLength || val.length > policy.maxlength) {
      return false;
    }
    // enforce lower/upper/alpha/numeric/special rules
    for (final rule in regexMap.keys) {
      if (regexMap[rule]!.allMatches(val).length < policy.toMap()["min$rule"]) {
        return false;
      }
    }
    // enforce word ban (case insensitive)
    for (var i = 0; i < policy.badWords.length; i++) {
      if (val.toLowerCase().contains(policy.badWords[i].toLowerCase())) {
        return false;
      }
    }
    // enforce the no sequential, identical characters rule
    if (policy.noSequential && sequentialRegex.hasMatch(val)) {
      return false;
    }
    // enforce alphanumeric/qwerty sequence ban rules
    if (policy.badSequenceLength > 0) {
      var lower = 'abcdefghijklmnopqrstuvwxyz';
      var upper = lower.toUpperCase();
      var numbers = '0123456789';
      var qwerty = 'qwertyuiopasdfghjklzxcvbnm';
      var start = policy.badSequenceLength - 1;
      var seq = '_${val.substring(0, start)}';

      for (var i = start; i < val.length; i++) {
        seq = seq.substring(1) + val[i];
        if (lower.contains(seq) ||
            upper.contains(seq) ||
            numbers.contains(seq) ||
            (policy.noQwertySequences && qwerty.contains(seq))) {
          return false;
        }
      }
    }
    // enforce custom regex/function rules
    if (policy.custom != null && !policy.custom!.hasMatch(val)) {
      return false;
    }
    // great success!
    return true;
  }

  static bool validateSimpleChars(String val) {
    return val.isNotEmpty && slugCharRegex.hasMatch(val);
  }

  static bool validateReallySimpleChars(String val) {
    return val.isNotEmpty && reallySimpleCharRegex.hasMatch(val);
  }

  static bool validateSlugChars(String val) {
    return val.isNotEmpty && slugCharRegex.hasMatch(val);
  }

  static bool validateSimpleSlugChars(String val) {
    return val.isNotEmpty && simpleSlugCharRegex.hasMatch(val);
  }

  static bool validateDomainChars(String val) {
    return val.isNotEmpty && domainCharRegex.hasMatch(val);
  }

  static bool validateHref(String val) {
    return val.isNotEmpty && hrefRegex.hasMatch(val);
  }

  static bool validateInteger(String val) {
    return val.isNotEmpty && int.tryParse(val) != null;
  }

  static bool validateRegex(String val, RegExp regex) {
    return val.isNotEmpty && regex.hasMatch(val);
  }

  // Temporary
  static bool validatePhone(String val) {
    return val.isNotEmpty && phoneRegex.hasMatch(val);
  }
}
