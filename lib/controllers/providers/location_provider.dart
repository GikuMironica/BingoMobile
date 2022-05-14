import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/configurations.dart';
import 'package:hopaut/data/domain/coordinate.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/utils/rounding_decimals.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart' as l;
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import 'package:geocode/geocode.dart' as geocoder;

@singleton
class LocationServiceProvider extends ChangeNotifier {
  l.Location location = l.Location();
  UserLocation? userLocation;
  String? countryCode;

  LocationServiceProvider() {
    getActualLocation();
    listenToUpdates();
  }

  Future<UserLocation?> getActualLocation() async {
    bool isLocationEnabled = await _isLocationServiceEnabledAndAllowed();
    if (!isLocationEnabled) {
      return null;
    }
    l.LocationData locationData = await _getLocation();
    userLocation = UserLocation(locationData.latitude, locationData.longitude);

    if (countryCode == null) {
      try {
        var address = await geocoder.GeoCode().reverseGeocoding(
            latitude: userLocation!.latitude!,
            longitude: userLocation!.longitude!);
        countryCode = address.countryCode;
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
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      showNewErrorSnackbar(
          LocaleKeys.Others_Services_Location_serviceDisabled.tr());
      var accepted = await location.requestService();
      if (!accepted) return false;
    }
    isLocationTrackingAllowed = await location.hasPermission();
    if (isLocationTrackingAllowed != l.PermissionStatus.granted &&
        isLocationTrackingAllowed != l.PermissionStatus.grantedLimited) {
      isLocationTrackingAllowed = await location.requestPermission();
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
    l.LocationData locationData = await location.getLocation();
    return locationData;
  }

  Future<void> listenToUpdates() async {
    var _lastLocation;
    await location.changeSettings(
        accuracy: l.LocationAccuracy.high, distanceFilter: 10);
    location.onLocationChanged.listen((e) async {
      if (e != null) {
        final newLatitude = roundOff(6, e.latitude!);
        final newLongtiude = roundOff(6, e.longitude!);
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
