/// id : "ac6d987d-ead3-4990-b7e3-c64ad184cdcf"
/// title : "Code with Tcode studio"
/// description : "fsadfasdf f aa fsa"
/// price : 900
/// offer_price : 800
/// delivery_charge : 40
/// cod : true
/// star_5 : 0
/// star_4 : 0
/// star_3 : 0
/// star_2 : 0
/// star_1 : 0
/// options : [{"id":"1525ca45-eaa9-4e7d-b6da-e4aa2426c1c1","option":"Hard Cover","quantity":7,"images":[{"position":0,"image":"/media/product/istockphoto-483960103-170667a_jl1RSec.jpg","product_option":"1525ca45-eaa9-4e7d-b6da-e4aa2426c1c1"}]},{"id":"9e501e87-5e22-4320-9ae8-da3a439d6bcc","option":"Soft Paper Cover","quantity":6,"images":[{"position":0,"image":"/media/product/istockphoto-483960103-170667a.jpg","product_option":"9e501e87-5e22-4320-9ae8-da3a439d6bcc"}]},{"id":"00d68240-38a8-435c-b7ba-b33daade8e31","option":"Plastic Pages","quantity":6,"images":[{"position":0,"image":"/media/product/c887f58a-7db9-4b35-85db-15573ce3b515.__CR00970600_PT0_SX970_V1___.jpg","product_option":"00d68240-38a8-435c-b7ba-b33daade8e31"}]}]

class ProductDetailsModel {
  ProductDetailsModel({
      String? id, 
      String? title, 
      String? description, 
      int? price, 
      int? offerPrice, 
      int? deliveryCharge, 
      bool? cod, 
      int? star5, 
      int? star4, 
      int? star3, 
      int? star2, 
      int? star1, 
      List<Options>? options,}){
    _id = id;
    _title = title;
    _description = description;
    _price = price;
    _offerPrice = offerPrice;
    _deliveryCharge = deliveryCharge;
    _cod = cod;
    _star5 = star5;
    _star4 = star4;
    _star3 = star3;
    _star2 = star2;
    _star1 = star1;
    _options = options;
}

  ProductDetailsModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _price = json['price'];
    _offerPrice = json['offer_price'];
    _deliveryCharge = json['delivery_charge'];
    _cod = json['cod'];
    _star5 = json['star_5'];
    _star4 = json['star_4'];
    _star3 = json['star_3'];
    _star2 = json['star_2'];
    _star1 = json['star_1'];
    if (json['options'] != null) {
      _options = [];
      json['options'].forEach((v) {
        _options?.add(Options.fromJson(v));
      });
    }
  }
  String? _id;
  String? _title;
  String? _description;
  int? _price;
  int? _offerPrice;
  int? _deliveryCharge;
  bool? _cod;
  int? _star5;
  int? _star4;
  int? _star3;
  int? _star2;
  int? _star1;
  List<Options>? _options;

  String? get id => _id;
  String? get title => _title;
  String? get description => _description;
  int? get price => _price;
  int? get offerPrice => _offerPrice;
  int? get deliveryCharge => _deliveryCharge;
  bool? get cod => _cod;
  int? get star5 => _star5;
  int? get star4 => _star4;
  int? get star3 => _star3;
  int? get star2 => _star2;
  int? get star1 => _star1;
  List<Options>? get options => _options;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['price'] = _price;
    map['offer_price'] = _offerPrice;
    map['delivery_charge'] = _deliveryCharge;
    map['cod'] = _cod;
    map['star_5'] = _star5;
    map['star_4'] = _star4;
    map['star_3'] = _star3;
    map['star_2'] = _star2;
    map['star_1'] = _star1;
    if (_options != null) {
      map['options'] = _options?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1525ca45-eaa9-4e7d-b6da-e4aa2426c1c1"
/// option : "Hard Cover"
/// quantity : 7
/// images : [{"position":0,"image":"/media/product/istockphoto-483960103-170667a_jl1RSec.jpg","product_option":"1525ca45-eaa9-4e7d-b6da-e4aa2426c1c1"}]

class Options {
  Options({
      String? id, 
      String? option, 
      int? quantity, 
      List<Images>? images,}){
    _id = id;
    _option = option;
    _quantity = quantity;
    _images = images;
}

  Options.fromJson(dynamic json) {
    _id = json['id'];
    _option = json['option'];
    _quantity = json['quantity'];
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images?.add(Images.fromJson(v));
      });
    }
  }
  String? _id;
  String? _option;
  int? _quantity;
  List<Images>? _images;

  String? get id => _id;
  String? get option => _option;
  int? get quantity => _quantity;
  List<Images>? get images => _images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['option'] = _option;
    map['quantity'] = _quantity;
    if (_images != null) {
      map['images'] = _images?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// position : 0
/// image : "/media/product/istockphoto-483960103-170667a_jl1RSec.jpg"
/// product_option : "1525ca45-eaa9-4e7d-b6da-e4aa2426c1c1"

class Images {
  Images({
      int? position, 
      String? image, 
      String? productOption,}){
    _position = position;
    _image = image;
    _productOption = productOption;
}

  Images.fromJson(dynamic json) {
    _position = json['position'];
    _image = json['image'];
    _productOption = json['product_option'];
  }
  int? _position;
  String? _image;
  String? _productOption;

  int? get position => _position;
  String? get image => _image;
  String? get productOption => _productOption;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['position'] = _position;
    map['image'] = _image;
    map['product_option'] = _productOption;
    return map;
  }

}