import 'dart:async';

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
  UserLocation userLocation;

  LocationServiceProvider() {
    _getActualLocation();
    listenToUpdates();
  }

  Future<UserLocation> _getActualLocation() async {
    _location = l.Location();
    bool isLocationEnabled = await _isLocationServiceEnabled();
    if(!isLocationEnabled){
      // TODO handle
      return null;
    }
    l.LocationData locationData = await _getLocation();
    userLocation = UserLocation(locationData.latitude, locationData.longitude);
    notifyListeners();
    return userLocation;
  }

  Future<bool> _isLocationServiceEnabled() async{
    bool serviceEnabled;
    l.PermissionStatus isLocationTrackingAllowed;
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      // TODO translation
      showNewErrorSnackbar('Location service is disabled');
      var accepted = await _location.requestService();
      if(!accepted)
        return false;
    }
    isLocationTrackingAllowed = await _location.hasPermission();
    if (isLocationTrackingAllowed != l.PermissionStatus.granted
        && isLocationTrackingAllowed != l.PermissionStatus.grantedLimited) {
      isLocationTrackingAllowed = await _location.requestPermission();
      if(isLocationTrackingAllowed != l.PermissionStatus.granted
        && isLocationTrackingAllowed != l.PermissionStatus.grantedLimited){
        // TODO translate
        showNewErrorSnackbar('Location permission denied');
        return false;
      }
    }
    return true;
  }

  Future<l.LocationData> _getLocation() async {
    l.LocationData locationData = await _location.getLocation();
    return locationData;
  }

  Future<void> listenToUpdates() async{
    var _lastLocation;
    _location.onLocationChanged.listen((e) async {
      if(e != null) {
        final newLatitude = roundOff(5, e.latitude);
        final newLongtiude = roundOff(5, e.longitude);
        if (_lastLocation != null) {
          if (_lastLocation.latitude != newLatitude &&
              _lastLocation.longitude != newLongtiude) {
            userLocation = UserLocation(newLatitude, newLongtiude);
          }
        } else {
          final userLocation = UserLocation(newLatitude, newLongtiude);
          this.userLocation = userLocation;
        }
      }
    });
  }
}
