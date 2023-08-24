import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/create_ticket_form_notifier.dart';

class CreateTicketField extends StatelessWidget {
  const CreateTicketField({
    super.key,
    this.label,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.enabled,
    required this.fieldName,
    this.onChanged,
    this.initialValue,
  });

  final String? label;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool? enabled;
  final String fieldName;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTicketFormNotifier>(
      builder: (context, provider, child) {
        return TextFormField(
          enabled: enabled,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
          ),
          keyboardType: keyboardType,
          readOnly: readOnly,
          onChanged: onChanged,
          initialValue: initialValue,
        );
      },
    );
  }
}
