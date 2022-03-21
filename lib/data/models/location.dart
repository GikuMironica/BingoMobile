class Location {
  int id = -1;
  double longitude = 0;
  double latitude = 0;
  String entityName = "";
  String address = "";
  String city = "";
  String region = "";
  String country = "";

  Location(
      {required this.id,
      required this.longitude,
      required this.latitude,
      required this.entityName,
      required this.address,
      required this.city,
      required this.region,
      required this.country});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    longitude = json['Longitude'];
    latitude = json['Latitude'];
    entityName = json['EntityName'];
    address = json['Address'];
    city = json['City'];
    region = json['Region'];
    country = json['Country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Longitude'] = this.longitude;
    data['Latitude'] = this.latitude;
    data['EntityName'] = this.entityName;
    data['Address'] = this.address;
    data['City'] = this.city;
    data['Region'] = this.region;
    data['Country'] = this.country;
    return data;
  }
}
