class Location {
  int id;
  int longitude;
  int latitude;
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
    longitude = json['Logitude'];
    latitude = json['Latitude'];
    entityName = json['EntityName'];
    address = json['Address'];
    city = json['City'];
    region = json['Region'];
    country = json['Country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Id'] = this.id;
    data['Logitude'] = this.longitude;
    data['Latitude'] = this.latitude;
    data['EntityName'] = this.entityName;
    data['Address'] = this.address;
    data['City'] = this.city;
    data['Region'] = this.region;
    data['Country'] = this.country;
    return data;
  }
}