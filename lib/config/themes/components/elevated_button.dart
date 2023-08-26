import '../../../config/utils/exports.dart';

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: UColors.blue600,
    foregroundColor: UColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(USpace.space8),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: USpace.space12,
      horizontal: USpace.space24,
    ),
    textStyle: const UTextStyle().textbasefontmedium,
  ),
);
