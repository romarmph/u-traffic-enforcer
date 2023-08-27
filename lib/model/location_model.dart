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
}
