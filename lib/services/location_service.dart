import 'package:geolocator/geolocator.dart';

import '../models/geo_point.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Future<bool> _ensurePermission() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<GeoPoint?> getCurrentLocation() async {
    final ok = await _ensurePermission();
    if (!ok) return null;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return GeoPoint(pos.latitude, pos.longitude);
  }
}
