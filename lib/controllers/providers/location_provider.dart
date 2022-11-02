import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/configurations.dart';
import 'package:hopaut/data/domain/coordinate.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/utils/rounding_decimals.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart' as l;
import 'package:geocoder/geocoder.dart' as geocoder;
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

@lazySingleton
class LocationServiceProvider extends ChangeNotifier {
  l.Location _location;
  UserLocation userLocation;
  String countryCode;

  LocationServiceProvider() {
    getActualLocation();
    listenToUpdates();
  }

  Future<UserLocation> getActualLocation() async {
    _location = l.Location();
    bool isLocationEnabled = await _isLocationServiceEnabledAndAllowed();
    if (!isLocationEnabled) {
      return null;
    }
    l.LocationData locationData = await _getLocation();
    userLocation = UserLocation(locationData.latitude, locationData.longitude);

    if (countryCode == null) {
      try {
        var coordinates = new geocoder.Coordinates(
            userLocation.latitude, userLocation.longitude);
        var address = await geocoder.Geocoder.local
            .findAddressesFromCoordinates(coordinates);
        countryCode = address.first.countryCode;
      } catch (e) {
        countryCode = Configurations.COUNTRY_CODE;
      }
    }

    notifyListeners();
    return userLocation;
  }

  Future<bool> _isLocationServiceEnabledAndAllowed() async {
    bool serviceEnabled;
    l.PermissionStatus isLocationTrackingAllowed;
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      showNewErrorSnackbar(
          LocaleKeys.Others_Services_Location_serviceDisabled.tr());
      var accepted = await _location.requestService();
      if (!accepted) return false;
    }
    isLocationTrackingAllowed = await _location.hasPermission();
    if (isLocationTrackingAllowed != l.PermissionStatus.granted &&
        isLocationTrackingAllowed != l.PermissionStatus.grantedLimited) {
      isLocationTrackingAllowed = await _location.requestPermission();
      if (isLocationTrackingAllowed != l.PermissionStatus.granted &&
          isLocationTrackingAllowed != l.PermissionStatus.grantedLimited) {
        showNewErrorSnackbar(
            LocaleKeys.Others_Services_Location_locationPermissionDenied.tr());
        return false;
      }
    }
    return true;
  }

  Future<l.LocationData> _getLocation() async {
    l.LocationData locationData = await _location.getLocation();
    return locationData;
  }

  Future<void> listenToUpdates() async {
    var _lastLocation;
    await _location.changeSettings(
        accuracy: l.LocationAccuracy.high, distanceFilter: 10);
    _location.onLocationChanged.listen((e) async {
      if (e != null) {
        final newLatitude = roundOff(6, e.latitude);
        final newLongtiude = roundOff(6, e.longitude);
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
