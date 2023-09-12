import '../../../config/utils/exports.dart';

class CreateTicketFormNotifier extends ChangeNotifier {
  static final _formatter = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z]+|\s"),
  );

  bool _noDriver = false;
  bool _ownedByDriver = false;

  String _licenseImagePath = "";

  Set<String?> _selectedViolationsID = {};

  final Map<TicketField, dynamic> _vehicleFormData = {
    TicketField.vehicleType: "",
    TicketField.engineNumber: "",
    TicketField.chassisNumber: "",
    TicketField.plateNumber: "",
    TicketField.vehicleOwner: "",
    TicketField.vehicleOwnerAddress: "",
  };

  final Map<TicketField, dynamic> _driverFormData = {
    TicketField.licenseNumber: "",
    TicketField.lastName: "",
    TicketField.firstName: "",
    TicketField.middleName: "",
    TicketField.birthDate: "",
    TicketField.phone: "",
    TicketField.email: "",
    TicketField.address: "",
  };

  final Map<TicketField, FormSettings> _formSettings = {
    TicketField.firstName: FormSettings(
      label: "First Name",
      errorMessage: "Please enter a valid name",
      formatters: [_formatter],
      type: TicketFieldType.driver,
    ),
    TicketField.middleName: FormSettings(
      label: "Middle Name",
      errorMessage: "Please enter a valid name",
      formatters: [_formatter],
      type: TicketFieldType.driver,
    ),
    TicketField.lastName: FormSettings(
      label: "Last Name",
      errorMessage: "Please enter a valid name",
      formatters: [_formatter],
      type: TicketFieldType.driver,
    ),
    TicketField.birthDate: FormSettings(
      label: "Birthdate",
      type: TicketFieldType.driver,
      errorMessage: "Please enter a valid date",
    ),
    TicketField.phone: FormSettings(
      label: "Phone Number",
      errorMessage: "Please enter a valid phone number",
      type: TicketFieldType.driver,
      keyboardType: TextInputType.phone,
    ),
    TicketField.email: FormSettings(
      label: "Email",
      errorMessage: "Please enter a valid email address",
      type: TicketFieldType.driver,
      keyboardType: TextInputType.emailAddress,
    ),
    TicketField.address: FormSettings(
      label: "Address",
      type: TicketFieldType.driver,
    ),
    TicketField.licenseNumber: FormSettings(
      label: "License Number",
      errorMessage: "Please enter a License Number",
      type: TicketFieldType.driver,
    ),
    TicketField.plateNumber: FormSettings(
      label: "Plate Number",
      errorMessage: "Please enter valid plate number",
      type: TicketFieldType.vehicle,
    ),
    TicketField.chassisNumber: FormSettings(
      label: "Chassis Number",
      errorMessage: "Please enter valid chassis number",
      type: TicketFieldType.vehicle,
    ),
    TicketField.engineNumber: FormSettings(
      label: "Engine Number",
      errorMessage: "Please enter valid engine number",
      type: TicketFieldType.vehicle,
    ),
    TicketField.vehicleType: FormSettings(
      label: "Vehicle Type",
      errorMessage: "Please enter valid vehicle type",
      type: TicketFieldType.vehicle,
    ),
    TicketField.vehicleOwner: FormSettings(
      label: "Vehicle Owner",
      errorMessage: "Please enter valid name",
      type: TicketFieldType.vehicle,
    ),
    TicketField.vehicleOwnerAddress: FormSettings(
      label: "Vehicle Owner Address",
      errorMessage: "Please enter valid address",
      type: TicketFieldType.vehicle,
    ),
  };

  ///
  ///
  /// ------------------- GETTERS
  ///
  ///

  Set<String?> get selectedViolationsID => _selectedViolationsID;

  bool get noDriver => _noDriver;
  bool get ownedByDriver => _ownedByDriver;
  String get licenseImagePath => _licenseImagePath;

  Map<TicketField, dynamic> get driverFormData => _driverFormData;
  Map<TicketField, dynamic> get vehicleFormData => _vehicleFormData;

  Map<TicketField, FormSettings> get formSettings => _formSettings;

  ///
  ///
  /// ------------------- SETTERS
  ///
  ///

  String? validateName(String? value, TicketField field) {
    switch (field) {
      case TicketField.firstName:
        {
          if (value == null || value.isEmpty) {
            return 'First name is required.';
          }
          if (!value.isValidName) {
            return 'First name must be valid.';
          }
          return null;
        }

      case TicketField.middleName:
        {
          if (value!.isNotEmpty && !value.isValidName) {
            return 'Middle name must be valid.';
          }
          return null;
        }
      default:
        {
          if (value == null || value.isEmpty) {
            return 'Last name is required.';
          }
          if (!value.isValidName) {
            return 'Last name must be valid.';
          }
          return null;
        }
    }
  }

  String? validatePhone(String? value) {
    if (!value!.isValidPhone) {
      return 'Phone number must be valid.';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty && !value.isValidEmail) {
      return 'Email must be valid.';
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == " ") {
      return null;
    }

    if (value == null || value.isEmpty) {
      return 'Date of birth is required.';
    }
    if (!value.isValidDate) {
      return 'Date of birth must be valid.';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == " ") {
      return null;
    }

    if (value == null || value.isEmpty) {
      return 'Address is required.';
    }
    return null;
  }

  String? validateLicenseNumber(String? value) {
    if (value == " " || value!.isEmpty) {
      return null;
    }
    final licenseNumberRegex = RegExp(r'^[A-Z]\d{2}-\d{2}-\d{6}$');
    if (!licenseNumberRegex.hasMatch(value)) {
      return 'Invalid license number format';
    }
    return null;
  }

  String? validateVehicleType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vehicle Type is required';
    }

    return null;
  }

  String? validatePlateNumber(String? value) {
    if (value == " " || value!.isEmpty) {
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

  void updateDriverFormField(TicketField field, dynamic value) {
    _driverFormData[field] = value;
    notifyListeners();
  }

  void updateVehicleFormField(TicketField field, dynamic value) {
    _vehicleFormData[field] = value;
    notifyListeners();
  }

  void setNoDriver(bool value) {
    _noDriver = value;
    _ownedByDriver = false;

    notifyListeners();
  }

  void setOwnedByDriver(bool value) {
    _ownedByDriver = value;
    if (value && !_noDriver) {
      String firstName = _formSettings[TicketField.firstName]!.controller!.text;
      String middleName =
          _formSettings[TicketField.middleName]!.controller!.text;
      String lastName = _formSettings[TicketField.lastName]!.controller!.text;

      _formSettings[TicketField.vehicleOwner]!.controller!.text =
          "$lastName, $firstName $middleName";

      _formSettings[TicketField.vehicleOwnerAddress]!.controller!.text =
          _formSettings[TicketField.address]!.controller!.text;
    } else {
      _formSettings[TicketField.vehicleOwner]!.controller!.clear();
      _formSettings[TicketField.vehicleOwnerAddress]!.controller!.clear();
    }
    notifyListeners();
  }

  void clearDriverFields([bool value = false]) {
    _formSettings.forEach((key, value) {
      value.controller!.clear();
    });

    _driverFormData.forEach((key, value) {
      _driverFormData[key] = "";
    });

    _licenseImagePath = "";

    _noDriver = value;
  }

  void setViolationsID(Set<String?> vioaltionsID) {
    _selectedViolationsID = vioaltionsID;
    notifyListeners();
  }

  void setLicenseImagePath(String path) {
    _licenseImagePath = path;
    notifyListeners();
  }
}
