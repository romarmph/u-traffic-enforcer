class Province {
  final String id;
  final String name;
  final String regionCode;
  final String href;

  const Province({
    required this.id,
    required this.name,
    required this.regionCode,
    required this.href,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: json['name'],
      regionCode: json['region_code'],
      href: json['href'],
    );
  }

  static List<Province> fromJsonList(List list) {
    return list.map((item) => Province.fromJson(item)).toList();
  }

  String provinceAsString() {
    return '#$id $name';
  }

  bool isEqual(Province model) {
    return id == model.id;
  }

  @override
  String toString() => name;
}
