import 'dart:collection';
import 'package:hopaut/config/event_types.dart';
import 'package:recase/recase.dart';

class SearchQuery {
  double latitude;
  double longitude;
  int radius;
  HashMap<EventType, bool> eventTypes;
  bool today;
  String tag;

  SearchQuery(
      {this.latitude,
      this.longitude,
      this.radius,
      this.today = false,
      this.tag = ''}) {
    eventTypes = HashMap();
    for (EventType value in EventType.values) {
      eventTypes[value] = false;
    }
  }

  // TODO not used
  String toString() {
    String x = "";

    this.toJson().forEach((k, v) {
      if (v is bool) {
        if (!v) return null;
      }
      if (v is String) {
        if (v.length == 0) return null;
      }
      x = x + '&$k=$v';
    });
    return x.replaceFirst('&', '');
  }

  // TODO not used
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['UserLocation.Latitude'] = this.latitude;
    data['UserLocation.Longitude'] = this.longitude;
    data['UserLocation.RadiusRange'] = this.radius;
    for (var eventType in EventType.values) {
      data[eventType.toString().pascalCase] = eventTypes[eventType];
    }
    data['Today'] = this.today;
    data['Tag'] = this.tag;
    return data;
  }
}
