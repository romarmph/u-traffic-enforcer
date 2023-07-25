class Violation {
  final String? id;
  final double fineAmount;
  final String name;
  final String description;

  const Violation({
    this.id,
    required this.fineAmount,
    required this.name,
    required this.description,
  });
}
