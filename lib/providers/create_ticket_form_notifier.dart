import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_traffic_enforcer/config/extensions/input_validator.dart';
import 'package:u_traffic_enforcer/model/form_input_settings.dart';

class CreateTicketFormNotifier extends ChangeNotifier {
  static final _formatter = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z]+|\s"),
  );

  bool _enabledField = false;
  bool _readOnlyField = false;

  final Map<String, dynamic> _vehicleFormFields = {
    'violationsID': <Set<String>>{},
    'vehicleType': "",
    'engineNumber': "",
    'chassisNumber': "",
    'plateNumber': "",
    'vehicleOwner': "",
    'vehicleOwnerAddress': "",
  };

  final Map<String, dynamic> _driverFormFields = {
    'licenseNumber': "",
    'firstName': "",
    'middleName': "",
    'lastName': "",
    'birthDate': "",
    'phone': "",
    'email': "",
    'address': "",
  };

  final _driverFormkey = GlobalKey<FormState>();
  final _vehicleFormKey = GlobalKey<FormState>();

  final FormSettings _firstName = FormSettings(
    fieldName: "firstName",
    label: "First Name",
    errorMessage: "Please enter a valid name",
    formatters: [_formatter],
  );

  final FormSettings _middleName = FormSettings(
    fieldName: "middleName",
    label: "Middle Name",
    errorMessage: "Please enter a valid name",
    formatters: [_formatter],
  );

  final FormSettings _lastName = FormSettings(
    fieldName: "lastName",
    label: "Last Name",
    errorMessage: "Please enter a valid name",
    formatters: [_formatter],
  );

  final FormSettings _birthDate = FormSettings(
    fieldName: "birthDate",
    label: "Birthdate",
  );

  final FormSettings _phone = FormSettings(
    fieldName: "phone",
    label: "Phone Number",
    errorMessage: "Please enter a valid phone number",
  );

  final FormSettings _email = FormSettings(
    fieldName: "email",
    label: "Email",
    errorMessage: "Please enter a valid email address",
  );

  final FormSettings _address = FormSettings(
    fieldName: "address",
    label: "Address",
  );

  final FormSettings _licenseNumber = FormSettings(
    fieldName: "licenseNumber",
    label: "License Number",
    errorMessage: "Please enter a License Number",
  );

  ///
  ///
  /// ------------------- GETTERS
  ///
  ///

  GlobalKey get driverFormKey => _driverFormkey;
  GlobalKey get vehicleFormKey => _vehicleFormKey;

  bool get enabledField => _enabledField;
  bool get readOnlyField => _readOnlyField;

  Map<String, dynamic> get driverFormData => _driverFormFields;
  Map<String, dynamic> get vehicleFormData => _vehicleFormFields;

  FormSettings get firstName => _firstName;
  FormSettings get middleName => _middleName;
  FormSettings get lastName => _lastName;
  FormSettings get birthDate => _birthDate;
  FormSettings get phone => _phone;
  FormSettings get email => _email;
  FormSettings get address => _address;
  FormSettings get licenseNumber => _licenseNumber;

  ///
  ///
  /// ------------------- SETTERS
  ///
  ///

  String? validateName(String? value) {
    return value.isNotNull && !value!.isValidName
        ? firstName.errorMessage
        : null;
  }

  String? validatePhone(String? value) {
    return value.isNotNull && !value!.isValidPhone ? phone.errorMessage : null;
  }

  String? validateEmail(String? value) {
    return value.isNotNull && !value!.isValidEmail ? email.errorMessage : null;
  }

  void updateDriverFormField(String field, dynamic value) {
    _driverFormFields[field] = value;
    notifyListeners();
  }

  void updateVehicleFormField(String field, dynamic value) {
    _driverFormFields[field] = value;
    notifyListeners();
  }

  void disableFields(bool value) {
    _enabledField = value;
    print(driverFormData.toString());
    print(vehicleFormData.toString());
    notifyListeners();
  }

  void setReadOnly(bool value) {
    _readOnlyField = value;
    notifyListeners();
  }

  void clearDriverFields() {
    _driverFormkey.currentState!.reset();
    _vehicleFormKey.currentState!.reset();
    _enabledField = false;
  }
}
