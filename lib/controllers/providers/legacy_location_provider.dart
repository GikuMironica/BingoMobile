import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/cupertino.dart';

@singleton
class GeolocationProvider extends ChangeNotifier {
  Position _currentPosition;

  GeolocationProvider() {
    //getActualLocation();
    //onLocationChange();
    // Live location
    // var positionStream = Geolocator.getPositionStream(
    //         distanceFilter: 1, desiredAccuracy: LocationAccuracy.high)
    //     .listen((Position position) {
    //   _currentPosition = position;
    //   Fluttertoast.showToast(msg: "New Location");
    // });
  }

  Position get userLocation => _currentPosition;

  Future<Position> getActualLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return Future.error('Location permission is denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    print('Loc updated');
    _currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 10)) ??
        await Geolocator.getLastKnownPosition();
    print("LOcations"+_currentPosition.latitude.toString()+" "+_currentPosition.longitude.toString());
    notifyListeners();
    return _currentPosition;
  }

  Future<void> onLocationChange() async{
    Geolocator.getPositionStream(distanceFilter: 2,
        desiredAccuracy: LocationAccuracy.best).listen((position) {
          print('Position updated '+position.latitude.toString()+" "+position.longitude.toString());
          _currentPosition = position;
          notifyListeners();
    });

  }
}
