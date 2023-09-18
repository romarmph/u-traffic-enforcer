import 'package:intl/intl.dart';
import 'package:u_traffic_enforcer/config/utils/exports.dart';

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
      final inputFormatter = DateFormat('MMMM d, y');
      final outputFormatter = DateFormat('yyyy-MM-dd');

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

  Timestamp get toTimestamp {
    try {
      final stringDate = replaceAll('/', '-');
      final dateParts = stringDate.split('-');

      final date = DateTime.parse(
        [dateParts[2], dateParts[0], dateParts[1]].join('-'),
      );

      return Timestamp.fromDate(date);
    } catch (e) {
      rethrow;
    }
  }
}
