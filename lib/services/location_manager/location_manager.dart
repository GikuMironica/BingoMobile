import 'package:geolocator/geolocator.dart';

class LocationManager {
  static LocationManager _locationManager;
  Geolocator _geolocator;
  Position currentPosition;

  factory LocationManager(){
    return _locationManager ??= LocationManager._();
  }

  LocationManager._(){
    _geolocator = Geolocator()..forceAndroidLocationManager;
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    currentPosition = await _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}

  Geolocator get locator => _geolocator;
}