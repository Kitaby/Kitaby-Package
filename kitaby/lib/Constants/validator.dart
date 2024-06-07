import 'package:regexed_validator/regexed_validator.dart';

class Fieldvalidator {
  static String? validatename(String? value) {
    if (value == null) {
      return null;
    } else {
      if (value.isEmpty) {
        return "Name is Required";
      } else if (!validator.name(value)) {
        return "Must be a valid name";
      }
    }
    return null;
  }

  static String? validateemail(String? value) {
    if (value == null) {
      return null;
    } else {
      if (value.isEmpty) {
        return "Email is Required";
      } else if (!validator.email(value)) {
        return "Must be a valid email address";
      }
    }
    return null;
  }

  static String? validatepassword(String? value) {
    if (value == null) {
      return null;
    } else {
      if (value.isEmpty) {
        return "password is Required";
      } else if (!validator.password(value)) {
        return "Must be a valid password";
      }
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null) {
      return null;
    } else {
      if (value.isEmpty) {
        return "Phone number is Required";
      } else if (!validator.phone(value)) {
        return "Must be a valid phone number";
      }
    }
    return null;
  }

  static String? validatePinCode(String? value) {
    if (value == null) {
      return null;
    } else {
      if (value.isEmpty) {
        return "Code pin is Required";
      } else if (!isPin(value)) {
        return "Must be a valid pin code";
      }
    }
    return null;
  }

  static String? validateisbn(String? value) {
    if (value == null) {
      return null;
    } else {
      if (value.isEmpty) {
        return "isbn is Required";
      } else if (!isisbnvalid(value)) {
        return "Must be a valid isbn";
      }
    }
    return null;
  }

  static bool isPin(String em) {
    String p = r'^[1-9][0-9]{5}$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  static bool isisbnvalid(String em) {
    String p = r'^[0-9]{10}$|^[0-9]{13}$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }
}
