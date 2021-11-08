import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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
    if(await Permission.location.isGranted) {
      currentPosition =
      await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    } else {
      print("Location permission was not granted.");
      await Permission.location.request();
      getCurrentLocation();
    }
  }
}