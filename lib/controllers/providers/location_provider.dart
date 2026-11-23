import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/configurations.dart';
import 'package:hopaut/data/domain/coordinate.dart';
import 'package:hopaut/presentation/widgets/dialogs/permission_dialog.dart';
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
  bool _isLocationPermissionGranted;
  bool _isLocationServiceEnabled;

  LocationServiceProvider() {
    _location = l.Location();
  }

  Future<bool> areLocationPermissionsEnabled(BuildContext context) async {
    await _isLocationServiceEnabledAndAllowed();

    if (!_isLocationPermissionGranted || !_isLocationServiceEnabled) {
      // WidgetsBinding.instance.addPostFrameCallback((_) async {

      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => WillPopScope(
                onWillPop: () => Future.value(false),
                child: PermissionDialog(
                  svgAsset: 'assets/icons/svg/location_2.svg',
                  header: LocaleKeys.Home_PermissionDialog_header.tr(),
                  message: LocaleKeys.Home_PermissionDialog_message.tr(),
                  permissionButtonText: LocaleKeys
                      .Home_PermissionDialog_btn_location_permission.tr(),
                  locationButtonText: LocaleKeys
                      .Home_PermissionDialog_btn_location_service.tr(),
                  isLocationEnabled: _isLocationServiceEnabled,
                  isLocationPermissionGranted: _isLocationPermissionGranted,
                ),
              ));
    }

    if (_isLocationPermissionGranted && _isLocationServiceEnabled) return true;

    return false;
  }

  void initializedLocationProvider(BuildContext context) async {
    getActualLocation();
    listenToUpdates();
  }

  Future<UserLocation> getActualLocation() async {
    if (!_isLocationPermissionGranted) {
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

  Future<void> _isLocationServiceEnabledAndAllowed() async {
    _isLocationServiceEnabled = await _location.serviceEnabled();

    var isLocationTrackingAllowed = await _location.hasPermission();
    if (isLocationTrackingAllowed != l.PermissionStatus.granted &&
        isLocationTrackingAllowed != l.PermissionStatus.grantedLimited) {
      _isLocationPermissionGranted = false;
    } else {
      _isLocationPermissionGranted = true;
    }
  }

  Future<bool> requestLocationEnablingAsync() async {
    if (!_isLocationServiceEnabled) {
      var accepted = await _location.requestService();
      if (!accepted) return false;
    }
    return true;
  }

  Future<bool> requestLocationPermissionsAsync() async {
    var isLocationTrackingAllowed = await _location.requestPermission();

    if (isLocationTrackingAllowed != l.PermissionStatus.granted &&
        isLocationTrackingAllowed != l.PermissionStatus.grantedLimited) {
      showNewErrorSnackbar(
          LocaleKeys.Others_Services_Location_locationPermissionDenied.tr());
      return false;
    } else {
      _isLocationPermissionGranted = true;
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
