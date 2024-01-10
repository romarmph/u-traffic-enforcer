enum ShiftPeriod {
  morning,
  afternoon,
  night,
}

extension ShiftPeriodExtension on ShiftPeriod {
  String get name {
    switch (this) {
      case ShiftPeriod.morning:
        return 'morning';
      case ShiftPeriod.afternoon:
        return 'afternoon';
      case ShiftPeriod.night:
        return 'night';
      default:
        return '';
    }
  }

  bool get isOnDuty {
    final now = DateTime.now();
    switch (this) {
      case ShiftPeriod.morning:
        return now.hour >= 5 && now.hour < 13;
      case ShiftPeriod.afternoon:
        return now.hour >= 13 && now.hour < 21;
      case ShiftPeriod.night:
        final hour = now.hour < 5 ? now.hour + 24 : now.hour;
        return hour >= 21 && hour < 29;
      default:
        return false;
    }
  }
}
