class Identity {
  String sub;
  String jti;
  String email;
  String id;
  int nbf;
  int exp;
  int iat;

  Identity(
      {this.sub,
        this.jti,
        this.email,
        this.id,
        this.nbf,
        this.exp,
        this.iat});

  int get expiry => exp * 1000;
  String get userId => id;

  Identity.fromJson(Map<String, dynamic> json) {
    sub = json['sub'];
    jti = json['jti'];
    email = json['email'];
    id = json['id'];
    nbf = json['nbf'];
    exp = json['exp'];
    iat = json['iat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub'] = this.sub;
    data['jti'] = this.jti;
    data['email'] = this.email;
    data['id'] = this.id;
    data['nbf'] = this.nbf;
    data['exp'] = this.exp;
    data['iat'] = this.iat;
    return data;
  }
}