import '../config/utils/exports.dart';

class FormValidators {
  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required.';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty && !value.isValidEmail) {
      return 'Email must be valid.';
    }
    return null;
  }

  String? validateBithdate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required.';
    }

    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required.';
    }
    return null;
  }

  String? validateLicenseNumber(String? value, bool hasNoLicense) {
    if (hasNoLicense) {
      return null;
    }

    if (!hasNoLicense && value!.trim().isEmpty) {
      return 'License number is required.';
    }
    final licenseNumberRegex = RegExp(r'^[A-Z]\d{2}-\d{2}-\d{6}$');
    if (!licenseNumberRegex.hasMatch(value!)) {
      return 'Invalid license number format';
    }
    return null;
  }

  String? validateVehicleType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vehicle Type is required';
    }

    return null;
  }

  String? validatePlateNumber(String? value) {
    if (value!.trim().isEmpty) {
      return null;
    }

    RegExp r1 = RegExp(r'^[A-Za-z]{3}[- ]?\d{3,4}$');
    RegExp r2 = RegExp(r'^\d{4}-\d{7}$');
    RegExp r3 = RegExp(r'^[A-Za-z]{2}-\d{4}$');

    if (r1.hasMatch(value) || r2.hasMatch(value) || r3.hasMatch(value)) {
      return null;
    } else {
      return 'Invalid format. Click the help icon (?) for more info';
    }
  }

  String? validateEngineNumber(String? input) {
    RegExp r = RegExp(r'^[A-Za-z0-9- ]{0,17}$');

    if (r.hasMatch(input!)) {
      return null;
    } else {
      return 'Invalid engine number format';
    }
  }

  String? validateChassisNumber(String? input) {
    RegExp r = RegExp(r'^[A-Za-z0-9- ]{0,17}$');

    if (r.hasMatch(input!)) {
      return null;
    } else {
      return 'Invalid chassis number format';
    }
  }
}

final formValidatorProvider = Provider<FormValidators>((ref) {
  return FormValidators();
});
