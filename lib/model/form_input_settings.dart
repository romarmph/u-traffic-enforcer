import 'package:flutter/services.dart';

class FormSettings {
  final String label;
  final String? errorMessage;
  final List<TextInputFormatter> formatters;
  final String fieldName;

  FormSettings({
    required this.fieldName,
    required this.label,
    this.errorMessage,
    this.formatters = const [],
  });
}
