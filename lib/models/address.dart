class Address {
  Address({this.prefecture,this.city,this.town,this.postal, this.latitude,this.longitude});
  String prefecture; //都道府県
  String city; //区
  String town; //町
  String postal; //郵便番号
  String allStreetAddress; //全ての住所情報。
  String subStreetAddress;//

  double longitude; //経度
  double latitude; //緯度

  Address.fromMap(Map<String, dynamic> map) {
    prefecture = map['prefecture'] as String;
    city = map['city'] as String;
    town = map['town'] as String;
    postal = map['postal'] as String;
    allStreetAddress = map['allStreetAddress'] as String;
    subStreetAddress = map['subStreetAddress'] as String;
    latitude = map['latitude'] as double;
    longitude = map['longitude'] as double;
  }

  Map<String, dynamic> toMap() {
    return {
      'street': prefecture,
      'number': city,
      'complement': town,
      'district': postal,
      'zipCode': allStreetAddress,
      'city': subStreetAddress,
      'lat': latitude,
      'long': longitude,
    };
  }

}
