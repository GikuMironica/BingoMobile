class SearchQuery {
  double latitude;
  double longitude;
  int radius;
  bool houseParty;
  bool club;
  bool bar;
  bool carMeet;
  bool bikerMeet;
  bool bicycleMeet;
  bool streetParty;
  bool marathon;
  bool other;
  bool today;
  String tag;

  SearchQuery(
      {this.latitude,
        this.longitude,
        this.radius,
        this.houseParty = false,
        this.club = false,
        this.bar = false,
        this.carMeet = false,
        this.bikerMeet = false,
        this.bicycleMeet = false,
        this.streetParty = false,
        this.marathon = false,
        this.other = false,
        this.today = false,
        this.tag = ''});

  String toString(){
    String x = "";

    this.toJson().forEach((k,v){
      if (v is bool) {
        if (!v) return null;
      }
      if (v is String){
        if(v.length==0) return null;
      }
      x = x + '&$k=$v';
    });
    return x.replaceFirst('&', '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['UserLocation.Latitude'] = this.latitude;
    data['UserLocation.Longitude'] = this.longitude;
    data['UserLocation.RadiusRange'] = this.radius;
    data['HouseParty'] = this.houseParty;
    data['Club'] = this.club;
    data['Bar'] = this.bar;
    data['CarMeet'] = this.carMeet;
    data['BikerMeet'] = this.bikerMeet;
    data['BicycleMeet'] = this.bicycleMeet;
    data['StreetParty'] = this.streetParty;
    data['Marathon'] = this.marathon;
    data['Other'] = this.other;
    data['Today'] = this.today;
    data['Tag'] = this.tag;
    return data;
  }
}