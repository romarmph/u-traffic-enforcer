extension InputValidator on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
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
}

extension NullInputValidator on String? {
  bool get isNotNull => this != null;
}