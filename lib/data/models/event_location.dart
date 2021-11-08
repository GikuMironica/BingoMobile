import 'package:flutter/material.dart' show required;
import 'package:here_sdk/core.dart' show GeoCoordinates;

/// An object to represent the Event's location.
///
/// [latitude] and [longitude] is required.
class EventLocation {
  // ignore: unused_field
  int _id;
  final double longitude;
  final double latitude;
  final String entityName;
  final String city;
  final String region;
  final String country;
  final String address;

  EventLocation(
      {@required this.latitude,
      @required this.longitude,
      this.entityName,
      this.address,
      this.city,
      this.country,
      this.region,
      int id})
      : _id = id;

  factory EventLocation.fromJson(Map<String, dynamic> json) {
    return EventLocation(
      id: json['Id'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
      entityName: json['EntityName'] ?? '',
      address: json['Address'] ?? '',
      city: json['City'] ?? '',
      country: json['Country'] ?? '',
      region: json['Region'] ?? '',
    );
  }

  /// JSON representation of this object.
  Map<String, dynamic> toJson() => {
    'UserLocation.Latitude': latitude,
    'UserLocation.Longitude': longitude,
    'UserLocation.EntityName': entityName,
    'UserLocation.Address': address,
    'UserLocation.City': city,
    'UserLocation.Region': region,
    'UserLocation.Country': country
  };

  String toString() => toJson().toString();

  /// GeoCoordinates of this location, useful for HERE Maps.
  GeoCoordinates get coordinates => GeoCoordinates(latitude, longitude);
}
