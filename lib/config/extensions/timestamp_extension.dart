import '../utils/exports.dart';
import 'package:intl/intl.dart';

extension TimestampExtension on Timestamp {
  String get toAmericanDate {
    try {
      final formatter = DateFormat('MMMM d, y');

      final date = toDate();

      return formatter.format(date);
    } catch (e) {
      rethrow;
    }
  }

  String get toTime {
    try {
      final formatter = DateFormat('h:mm a');

      final date = toDate();

      return formatter.format(date);
    } catch (e) {
      rethrow;
    }
  }

  String get formattedDueDate {
    try {
      final formatter = DateFormat('MMMM d, y');

      final date = toDate().add(const Duration(
        days: 7,
      ));

      return formatter.format(date);
    } catch (e) {
      rethrow;
    }
  }
}
