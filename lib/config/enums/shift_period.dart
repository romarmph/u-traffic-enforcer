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
}
