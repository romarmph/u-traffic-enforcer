import 'package:flutter/material.dart';

import '../colors.dart';
import '../spacing.dart';
import '../textstyles.dart';

final textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: UColors.blue700,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(USpace.space8),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: USpace.space12,
      horizontal: USpace.space24,
    ),
    textStyle: const UTextStyle().textxsfontnormal,
  ),
);
