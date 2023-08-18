class Violation {
  final String id;
  final int fine;
  final String name;
  bool isSelected;

  Violation({
    this.isSelected = false,
    required this.id,
    required this.fine,
    required this.name,
  });

  factory Violation.fromJson(Map<String, dynamic> json, String id) {
    return Violation(
      id: id,
      fine: json['fine'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fine': fine,
        'name': name,
      };
}
