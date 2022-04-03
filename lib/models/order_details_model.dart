/// id : "4b5d30ac-34cb-4307-9714-aef3fea3a7ee"
/// title : "(Soft Paper Cover) Code with Tcode studio"
/// image : "/media/product/istockphoto-483960103-170667a.jpg"
/// created_at : "14 Mar 2022 07:30 AM"
/// quantity : 1
/// status : "ORDERED"
/// rating : 0
/// product_price : 800
/// tx_price : 840
/// delivery_price : 40
/// payment_mode : "Wallet"
/// address : "jay chudasama\n9898989888\nfasoasf\n370201Kachchh\nGujarat\n"
/// tx_id : "1383347"
/// tx_status : "SUCCESS"

class OrderDetailsModel {
  OrderDetailsModel({
      String? id, 
      String? title, 
      String? image, 
      String? createdAt, 
      int? quantity, 
      String? status, 
      int? rating, 
      int? productPrice, 
      int? txPrice, 
      int? deliveryPrice, 
      String? paymentMode, 
      String? address, 
      String? txId, 
      String? txStatus,}){
    _id = id;
    _title = title;
    _image = image;
    _createdAt = createdAt;
    _quantity = quantity;
    _status = status;
    _rating = rating;
    _productPrice = productPrice;
    _txPrice = txPrice;
    _deliveryPrice = deliveryPrice;
    _paymentMode = paymentMode;
    _address = address;
    _txId = txId;
    _txStatus = txStatus;
}

  OrderDetailsModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _quantity = json['quantity'];
    _status = json['status'];
    _rating = json['rating'];
    _productPrice = json['product_price'];
    _txPrice = json['tx_price'];
    _deliveryPrice = json['delivery_price'];
    _paymentMode = json['payment_mode'];
    _address = json['address'];
    _txId = json['tx_id'];
    _txStatus = json['tx_status'];
  }
  String? _id;
  String? _title;
  String? _image;
  String? _createdAt;
  int? _quantity;
  String? _status;
  int? _rating;
  int? _productPrice;
  int? _txPrice;
  int? _deliveryPrice;
  String? _paymentMode;
  String? _address;
  String? _txId;
  String? _txStatus;

  String? get id => _id;
  String? get title => _title;
  String? get image => _image;
  String? get createdAt => _createdAt;
  int? get quantity => _quantity;
  String? get status => _status;
  int? get rating => _rating;
  int? get productPrice => _productPrice;
  int? get txPrice => _txPrice;
  int? get deliveryPrice => _deliveryPrice;
  String? get paymentMode => _paymentMode;
  String? get address => _address;
  String? get txId => _txId;
  String? get txStatus => _txStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['quantity'] = _quantity;
    map['status'] = _status;
    map['rating'] = _rating;
    map['product_price'] = _productPrice;
    map['tx_price'] = _txPrice;
    map['delivery_price'] = _deliveryPrice;
    map['payment_mode'] = _paymentMode;
    map['address'] = _address;
    map['tx_id'] = _txId;
    map['tx_status'] = _txStatus;
    return map;
  }

}