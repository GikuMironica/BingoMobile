import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hopaut/data/domain/coordinate.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/utils/rounding_decimals.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as l;

@singleton
class LocationServiceProvider extends ChangeNotifier {
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  l.Location _location;
  UserLocation _userLocation;

  UserLocation get location => _userLocation;
  PermissionStatus get permissionStatus => _permissionStatus;

  LocationServiceProvider() {
    getActualLocation();
  }

  Future<UserLocation> getActualLocation() async {
    _location = l.Location();
    bool isLocationEnabled = await _isLocationServiceEnabled();
    if(!isLocationEnabled){
      // TODO handle
      return null;
    }
    await _getLocation();
  }

  Future<bool> _isLocationServiceEnabled() async{
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      // TODO translation
      showNewErrorSnackbar('Please enable location services');
      return false;
      //TODO log ask to enable permission
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied){
        //TODO log
        return false;
        return Future.error('Location permission are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
      // TODO log
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  Future<UserLocation> _getLocation() async {
    var locationData = await _location.getLocation();
    _userLocation =
        UserLocation(locationData.latitude, locationData.longitude);
    notifyListeners();
    return _userLocation;
  }
}
