import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/postal_address.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/users.dart';
import 'package:loja_virtual/models/user_manager.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  Users users;
  Address address;

  int productsPrice = 0;
  double deliveryPrice;

  int get totalPrice => (productsPrice + (deliveryPrice ?? 0)).round();

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateUser(UserManager userManager) {
    users = userManager.users;
    items.clear();
    removeAddress();/*前にログインしてた人のアドレス消す*/

    if (users != null) {
      _loadCartItems();
      _loadUserAddress();
    }
  }

  //ユーザー別のカート内情報を取得する
  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await users.cartRef.get();
    items = cartSnap.docs
        .map(
          (d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated),
        ).toList();
  }

  //ユーザーのアドレス情報取得
  Future<void> _loadUserAddress() async {
    if (users.address != null &&
        await calculateDelivery(
            users.address.latitude, users.address.longitude)) {
      address = users.address;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    try {
      /*既にカートに入っている場合*/
      final item = items.firstWhere((p) => p.stackable(product));
      item.increment();
    } catch (e) {
      /*カートに入っていない場合*/
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      users.cartRef
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.id); /*ユーザーのFirebase上のカートに追加*/
      _onItemUpdated();
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id); /*CartTile削除*/
    users.cartRef.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated); /*addListener不要になったらこれが必要*/
    notifyListeners();
  }

  void clear(){
    for(final cartProduct in items){/*Firebase上で消して*/
      users.cartRef.doc(cartProduct.id).delete();
    }
    items.clear();/*デバイス上で消す*/
    notifyListeners();
  }

  void _onItemUpdated() {
    productsPrice = 0;
    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];
      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--; /*一個消されたら次の商品のiが繰り下がる*/
        continue; /*次のcartProductにスキップ*/
      }
      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null) /*エラー対策？*/
      users.cartRef.doc(cartProduct.id).update(cartProduct.toCartItemMap());
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  //------------------------Address------------------------------

  bool _townSelectValue = false;

  bool get townSelectValue => _townSelectValue;

  set townSelect(bool select) {
    _townSelectValue = select;
    notifyListeners();
  }

  String _postAddress;

  String get postAddress => _postAddress;

  set postAddress(String value) {
    _postAddress = value;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  Future<void> getAddress(String postalCode) async {
    loading = true;
    //郵便番号情報取得API元　http://geoapi.heartrails.com/

    final url =
        'http://geoapi.heartrails.com/api/json?method=searchByPostal&postal=$postalCode';

    final Dio dio = Dio(); //Httpパッケージの上位ver

    try {
      Response response = await dio.get(url);
      final addressData =
          PostalAddress.fromMap(response.data); //jsonデーターを渡し、データを個別に抽出。
      address = Address(
        //Addressにデーターを移行。
        prefecture: addressData.prefecture,
        city: addressData.city,
        town: addressData.town,
        postal: addressData.postal,
        latitude: double.parse(addressData.latitude),
        longitude: double.parse(addressData.longitude),
      );
      loading = false;
    } catch (e) {
      loading = false;

      throw Future.error('無効です');
    }
  }

  void removeAddress() {
    address = null;
    _townSelectValue = false;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<void> setAddress(Address address) async {
    loading = true;

    this.address = address;
    if (await calculateDelivery(address.latitude, address.longitude)) {
      users.setAddress(address);
      loading = false;
    } else {
      loading = false;

      return Future.error('配達範囲外の住所です');
    }
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.doc('aux/delivery').get();
    //発送元の住所
    final latStore = doc.data()['lat'] as double;
    final longStore = doc.data()['long'] as double;
    final base = doc.data()['base'] as num;
    final km = doc.data()['km'] as num;
    final maxkm = doc.data()['maxkm'] as num;

    double dis =
        await Geolocator().distanceBetween(latStore, longStore, lat, long);

    dis /= 1000; /*m からkmへ*/
    if (dis > maxkm) {
      return false;
    }
    deliveryPrice = base + dis * km;
    return true;
  }
}
