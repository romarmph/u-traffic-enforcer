class City {
  final String id;
  final String name;
  final String regionCode;
  final String provinceCode;
  final String href;

  const City({
    required this.id,
    required this.name,
    required this.regionCode,
    required this.provinceCode,
    required this.href,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      regionCode: json['region_code'],
      provinceCode: json['province_code'],
      href: json['href'],
    );
  }

  static List<City> fromJsonList(List list) {
    return list.map((item) => City.fromJson(item)).toList();
  }

  String cityAsString() {
    return '#$id $name';
  }

  bool isEqual(City model) {
    return id == model.id;
  }

  @override
  String toString() => name;
}
