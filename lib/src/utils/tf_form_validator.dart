// Copyright (c) 2022 TechFusion Ltd (https://www.techfusion.dev).

import 'package:intl/intl.dart';
import 'package:tf_form/src/models/models.dart';

class TFFormValidator {
  // email regex: https://stackoverflow.com/a/61512807
  static final RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final RegExp phoneRegex = RegExp(r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
  static final RegExp simpleCharRegex = RegExp(r'^[a-zA-Z0-9_\.\ -]+$');
  static final RegExp domainCharRegex = RegExp(r'^[a-z0-9s]+(?:[-.][a-z0-9s]+)*$');
  static final RegExp slugCharRegex = RegExp(r'^[a-zA-Z0-9\s]+(?:[-_.][a-zA-Z0-9\s]+)*$');
  static final RegExp simpleSlugCharRegex = RegExp(r'^[a-zA-Z0-9\s]+(?:[-][a-zA-Z0-9\s]+)*$');
  static final RegExp reallySimpleCharRegex = RegExp(r'^[a-zA-Z0-9]+$');
  static final RegExp lowerCharRegex = RegExp(r'[a-z]');
  static final RegExp upperCharRegex = RegExp(r'[A-Z]');
  static final RegExp alphaCharRegex = RegExp(r'[a-zA-Z]');
  static final RegExp numericCharRegex = RegExp(r'[0-9]');
  static final RegExp specialCharRegex = RegExp(r'[\W_]');
  static final RegExp hrefRegex = RegExp(r'^[a-zA-Z0-9_/%:/.\-\+]+$');
  static final RegExp sequentialRegex = RegExp(r'([\S\s])\1');

  /////////////////////////////////////////////////////////////////
  static bool validateEmailAddress(String val) {
    return val.isNotEmpty && emailRegex.hasMatch(val);
  }

  static DateFormat getDateFormat() {
    String locale = Intl.getCurrentLocale();
    String dateFormatPattern = "dd/MM/yyyy";
    if (locale == "en_US") {
      dateFormatPattern = "MM/dd/yyyy";
    }
    final dateFormat = DateFormat(dateFormatPattern);
    return dateFormat;
  }

  static bool validateDate(String val) {
    try {
      getDateFormat().parse(val);
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
      "Numeric": numericCharRegex,
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
        if (lower.contains(seq) || upper.contains(seq) || numbers.contains(seq) || (policy.noQwertySequences && qwerty.contains(seq))) {
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
