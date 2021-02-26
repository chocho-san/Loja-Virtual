class PostalAddress {
  String prefecture; //都道府県
  String city; //区
  String town; //町
  String postal; //郵便番号
  String longitude; //経度
  String latitude; //緯度



  PostalAddress.fromMap(dynamic data) {
    prefecture = data['response']['location'][0]['prefecture'];
    city = data['response']['location'][0]['city'];
    town = data['response']['location'][0]['town'];
    postal = data['response']['location'][0]['postal'];
    longitude = data['response']['location'][0]['x'];
    latitude = data['response']['location'][0]['y'];
  }
}