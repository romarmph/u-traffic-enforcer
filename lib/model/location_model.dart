class ULocation {
  final String address;
  final double lat;
  final double long;

  const ULocation({
    required this.address,
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'lat': lat,
      'long': long,
    };
  }

  factory ULocation.fromJson(Map<String, dynamic> json) {
    return ULocation(
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
    );
  }
}
