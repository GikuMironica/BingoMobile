class Location {
  int id;
  double longitude;
  double latitude;
  String entityName;
  String address;
  String city;
  String region;
  String country;

  Location(
      {this.id,
        this.longitude,
        this.latitude,
        this.entityName,
        this.address,
        this.city,
        this.region,
        this.country});

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