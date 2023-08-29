import 'package:intl/intl.dart';

extension StringDate on String {
  String get formtDate {
    try {
      final formatter = DateFormat('EEE, M/d/y');

      final date = DateTime.parse(this);

      return formatter.format(date);
    } catch (e) {
      rethrow;
    }
  }

  DateTime? get tryParseToDateTime {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }
}
