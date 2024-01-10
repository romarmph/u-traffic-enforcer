import 'dart:async';

import 'package:geolocator/geolocator.dart';
import '../config/utils/exports.dart';
import 'package:geocoding/geocoding.dart' as geocoder;

class LocationServices {
  LocationServices._();

  static LocationServices get instance => LocationServices._();

  final _location = Location.instance;

  Future<ULocation> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('service-not-enabled');
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('permission-not-granted');
      }
    }

    locationData = await _location.getLocation();
    final address = await _getAddress(
      locationData.latitude,
      locationData.longitude,
    );

    return ULocation(
      address: address,
      lat: locationData.latitude!,
      long: locationData.longitude!,
    );
  }

  static Future<String> _getAddress(double? lat, double? long) async {
    final geoInstance = geocoder.GeocodingPlatform.instance;
    final place = await geoInstance.placemarkFromCoordinates(lat!, long!);

    return '${place[1].street!} ${place[1].subLocality!} ${place[1].locality!}';
  }

  final Geolocator geolocator = Geolocator();
}
