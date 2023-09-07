import 'package:email_validator/email_validator.dart';

extension InputValidator on String {
  bool get isValidEmail {
    return EmailValidator.validate(this);
  }

  bool get isValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^(?:[+0]9)?[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidDate {
    try {
      DateTime.parse(this);

      return true;
    } catch (e) {
      return false;
    }
  }
}

extension NullInputValidator on String? {
  bool get isNotNull => this != null;
}
