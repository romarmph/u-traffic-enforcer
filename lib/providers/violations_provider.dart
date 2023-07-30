import 'dart:collection';

import 'package:flutter/material.dart';

import '../model/violation_model.dart';

class ViolationProvider extends ChangeNotifier {
  final UnmodifiableListView<Violation> _violationsList =
      UnmodifiableListView<Violation>([
    Violation(
        fineAmount: 300,
        name: "No Driver's License",
        id: "1111111",
        isSelected: false),
    Violation(
        fineAmount: 300,
        name: "No Driver's License",
        id: "2222222",
        isSelected: false),
    Violation(
      fineAmount: 300,
      name: "No Driver's License",
      id: "33333333",
      isSelected: false,
    ),
  ]);

  List<Violation> get getViolations => _violationsList;

  void selectViolation(String id) {
    final int index = _violationsList.indexWhere((Violation v) => v.id == id);
    _violationsList[index].isSelected =
        _violationsList[index].isSelected ? false : true;
    notifyListeners();
  }
}
