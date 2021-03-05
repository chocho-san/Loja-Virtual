class Address {
  Address({this.prefecture,this.city,this.town,this.postal, this.latitude,this.longitude});
  String prefecture; //都道府県
  String city; //市区町村
  String town; //番地
  String postal; //郵便番号
  double longitude; //経度
  double latitude; //緯度

  Address.fromMap(Map<String, dynamic> map) {
    prefecture = map['prefecture'] as String;
    city = map['city'] as String;
    town = map['town'] as String;
    postal = map['postal'] as String;
    latitude = map['latitude'] as double;
    longitude = map['longitude'] as double;
  }

  Map<String, dynamic> toMap() {
    return {
      'prefecture': prefecture,
      'city': city,
      'town': town,
      'postal': postal,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

}
