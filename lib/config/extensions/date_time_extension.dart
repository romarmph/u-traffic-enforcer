import 'package:intl/intl.dart';

import '../utils/exports.dart';

extension DateTimeExtension on DateTime {
  Timestamp get toTimestamp {
    try {
      return Timestamp.fromDate(this);
    } catch (e) {
      rethrow;
    }
  }

  String get toAmericanDate {
    try {
      return DateFormat('MM/dd/yyyy').format(this);
    } catch (e) {
      rethrow;
    }
  }
}
