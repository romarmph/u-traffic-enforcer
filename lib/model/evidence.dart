class Evidence {
  final String? id;
  final int? ticketNumber;
  final String name;
  final String? description;
  final String path;

  const Evidence({
    this.id,
    this.ticketNumber,
    this.description,
    required this.name,
    required this.path,
  });

  Map<String, dynamic> toJson() {
    return {
      'ticketNumber': ticketNumber,
      'name': name,
      'description': description,
      'path': path,
    };
  }

  factory Evidence.fromMap(Map<String, dynamic> map, String id) {
    return Evidence(
      id: id,
      ticketNumber: map['ticketNumber'],
      name: map['name'],
      description: map['description'],
      path: map['path'],
    );
  }

  Evidence copyWith({
    String? id,
    int? ticketNumber,
    String? name,
    String? description,
    String? path,
  }) {
    return Evidence(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      name: name ?? this.name,
      description: description ?? this.description,
      path: path ?? this.path,
    );
  }
}
