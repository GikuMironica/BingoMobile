import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart' as l;
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

@singleton
class PermissionService with WidgetsBindingObserver{

  l.Location _location;

  PermissionService(){
    _location = l.Location();
  }

  Future<bool> isLocationPermissionEnabledAsync() async {
    var serviceEnabled = await _location.serviceEnabled();
    var isLocationTrackingAllowed = await _location.hasPermission();

    if(serviceEnabled
        && (isLocationTrackingAllowed == l.PermissionStatus.granted
        || isLocationTrackingAllowed == l.PermissionStatus.grantedLimited)) {
      return true;
    }
    return false;

  }
}
