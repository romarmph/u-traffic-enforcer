import 'package:u_traffic_enforcer/config/enums/shift_period.dart';

extension StringExtension on String? {
  String get replaceNull {
    if (this!.isEmpty) {
      return 'N/A';
    }

    if (this == null) {
      return 'N/A';
    }

    return this!;
  }

  int get toInt {
    if (this == null) {
      return 0;
    }

    return int.parse(this!);
  }

  ShiftPeriod get toShiftPeriod {
    switch (this) {
      case 'morning':
        return ShiftPeriod.morning;
      case 'afternoon':
        return ShiftPeriod.afternoon;
      case 'night':
        return ShiftPeriod.night;
      default:
        return ShiftPeriod.morning;
    }
  }

  String get capitalize {
    if (this == null) {
      return '';
    }

    return '${this![0].toUpperCase()}${this!.substring(1)}';
  }
}
