import 'package:flutter/material.dart' show required;
import 'package:here_sdk/core.dart' show GeoCoordinates;

class UserLocation {
  final double longitude;
  final double latitude;

  UserLocation({@required this.latitude, @required this.longitude});

  GeoCoordinates get coordinates => GeoCoordinates(latitude, longitude);
}