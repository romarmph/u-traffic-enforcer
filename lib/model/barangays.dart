class Barangay {
  final String id;
  final String name;
  final String regionCode;
  final String provinceCode;
  final String cityCode;
  final String href;

  const Barangay({
    required this.id,
    required this.name,
    required this.regionCode,
    required this.provinceCode,
    required this.cityCode,
    required this.href,
  });

  factory Barangay.fromJson(Map<String, dynamic> json) {
    return Barangay(
      id: json['id'],
      name: json['name'],
      regionCode: json['region_code'],
      provinceCode: json['province_code'],
      cityCode: json['city_code'],
      href: json['href'],
    );
  }

  static List<Barangay> fromJsonList(List list) {
    return list.map((item) => Barangay.fromJson(item)).toList();
  }

  String barangayAsString() {
    return '#$id $name';
  }

  bool isEqual(Barangay model) {
    return id == model.id;
  }

  @override
  String toString() => name;
}
