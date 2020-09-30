import 'package:geolocator/geolocator.dart';

class LocationManager {
  static LocationManager _locationManager;
  Position currentPosition;

  factory LocationManager(){
    return _locationManager ??= LocationManager._();
  }

  LocationManager._(){
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    currentPosition = await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}
}