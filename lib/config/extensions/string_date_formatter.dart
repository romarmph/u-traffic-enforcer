import 'package:intl/intl.dart';

extension StringDate on String {
  String get formtDate {
    try {
      final formatter = DateFormat('MMMM d, y');

      final date = DateTime.parse(this);

      return formatter.format(date);
    } catch (e) {
      rethrow;
    }
  }

  String reverseFormatDate() {
    try {
      final inputFormatter = DateFormat('MM-dd-yyyy');
      final outputFormatter = DateFormat('MMMM d, y');

      final date = inputFormatter.parse(this);
      final formattedDate = outputFormatter.format(date);

      return formattedDate;
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
