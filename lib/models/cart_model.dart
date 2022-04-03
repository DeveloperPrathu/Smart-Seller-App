/// id : "1525ca45-eaa9-4e7d-b6da-e4aa2426c1c1"
/// title : "(Hard Cover) Code with Tcode studio"
/// image : "/media/product/istockphoto-483960103-170667a_jl1RSec.jpg"
/// price : 900
/// offer_price : 800
/// quantity : 7
/// cod : true
/// delivery_charge : 40

class CartModel {
  CartModel({
      String? id, 
      String? title, 
      String? image, 
      int? price, 
      int? offerPrice, 
      int? quantity, 
      bool? cod, 
      int? deliveryCharge,}){
    _id = id;
    _title = title;
    _image = image;
    _price = price;
    _offerPrice = offerPrice;
    _quantity = quantity;
    _cod = cod;
    _deliveryCharge = deliveryCharge;
}

  CartModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _price = json['price'];
    _offerPrice = json['offer_price'];
    _quantity = json['quantity'];
    _cod = json['cod'];
    _deliveryCharge = json['delivery_charge'];
  }
  String? _id;
  String? _title;
  String? _image;
  int? _price;
  int? _offerPrice;
  int? _quantity;
  bool? _cod;
  int? _deliveryCharge;
  int selected_qty=1;

  String? get id => _id;
  String? get title => _title;
  String? get image => _image;
  int? get price => _price;
  int? get offerPrice => _offerPrice;
  int? get quantity => _quantity;
  bool? get cod => _cod;
  int? get deliveryCharge => _deliveryCharge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['image'] = _image;
    map['price'] = _price;
    map['offer_price'] = _offerPrice;
    map['quantity'] = _quantity;
    map['cod'] = _cod;
    map['delivery_charge'] = _deliveryCharge;
    return map;
  }

}