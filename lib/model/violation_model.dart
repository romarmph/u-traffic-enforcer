class Violation {
  final String? id;
  final int fineAmount;
  final String name;
  bool isSelected;

  Violation({
    this.id,
    this.isSelected = false,
    required this.fineAmount,
    required this.name,
  });
}
