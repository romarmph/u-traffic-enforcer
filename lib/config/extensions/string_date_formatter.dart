import 'package:intl/intl.dart';

extension StringDateFomat on String {
  String get formtDate {
    try {
      final formatter = DateFormat('EEE, M/d/y');

      final date = DateTime.parse(this);

      return formatter.format(date);
    } catch (e) {
      rethrow;
    }
  }
}
