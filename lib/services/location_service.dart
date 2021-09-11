import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class LocationService {
  Position _currentPosition;

  LocationService() {}

  Position get currentPosition => _currentPosition;

  Future<void> getCurrentLocation() async {
    if (await Permission.location.isGranted) {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } else {
      print("Location permission was not granted.");
      await Permission.location.request();
      getCurrentLocation();
    }
  }
}
