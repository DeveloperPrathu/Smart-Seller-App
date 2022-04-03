/// count : 3
/// next : null
/// previous : null
/// results : [{"id":1,"position":0,"image":null,"category":2,"title":"Limited Offer","viewtype":2,"product_options":[{"id":"ac6d987d-ead3-4990-b7e3-c64ad184cdcf","image":"/media/product/circle-cropped_rVQ82Rt.png","title":"(Plastic Pages) Code with Tcode studio","price":900,"offer_price":800},{"id":"ac6d987d-ead3-4990-b7e3-c64ad184cdcf","image":"/media/product/circle-cropped.png","title":"(Hard Cover) Code with Tcode studio","price":900,"offer_price":800},{"id":"ac6d987d-ead3-4990-b7e3-c64ad184cdcf","image":"/media/product/tcode.jpg","title":"(Soft Paper Cover) Code with Tcode studio","price":900,"offer_price":800}]},{"id":2,"position":1,"image":"/media/product/tcode_puiF8c9.jpg","category":2,"title":"","viewtype":1,"product_options":[]},{"id":3,"position":2,"image":null,"category":2,"title":"Special Discount","viewtype":3,"product_options":[{"id":"ac6d987d-ead3-4990-b7e3-c64ad184cdcf","image":"/media/product/circle-cropped_rVQ82Rt.png","title":"(Plastic Pages) Code with Tcode studio","price":900,"offer_price":800},{"id":"ac6d987d-ead3-4990-b7e3-c64ad184cdcf","image":"/media/product/circle-cropped.png","title":"(Hard Cover) Code with Tcode studio","price":900,"offer_price":800},{"id":"ac6d987d-ead3-4990-b7e3-c64ad184cdcf","image":"/media/product/tcode.jpg","title":"(Soft Paper Cover) Code with Tcode studio","price":900,"offer_price":800}]}]

class PageItemModel {
  PageItemModel({
      int? count, 
      dynamic next, 
      dynamic previous, 
      List<Results>? results,}){
    _count = count;
    _next = next;
    _previous = previous;
    _results = results;
}

  PageItemModel.fromJson(dynamic json) {
    _count = json['count'];
    _next = json['next'];
    _previous = json['previous'];
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(Results.fromJson(v));
      });
    }
  }
  int? _count;
  dynamic _next;
  dynamic _previous;
  List<Results>? _results;

  int? get count => _count;
  dynamic get next => _next;
  dynamic get previous => _previous;
  List<Results>? get results => _results;


  set results(List<Results>? value) {
    _results = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['next'] = _next;
    map['previous'] = _previous;
    if (_results != null) {
      map['results'] = _results?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// position : 0
/// image : null
/// category : 2
/// title : "Limited Offer"
/// viewtype : 2
/// product_options : [{"id":"ac6d987d-ead3-4990-b7e3-c64ad184cdcf","image":"/media/product/circle-cropped_rVQ82Rt.png","title":"(Plastic Pages) Code with Tcode studio","price":900,"offer_price":800},{"id":"ac6d987d-ead3-4990-b7e3-c64ad184cdcf","image":"/media/product/circle-cropped.png","title":"(Hard Cover) Code with Tcode studio","price":900,"offer_price":800},{"id":"ac6d987d-ead3-4990-b7e3-c64ad184cdcf","image":"/media/product/tcode.jpg","title":"(Soft Paper Cover) Code with Tcode studio","price":900,"offer_price":800}]

class Results {
  Results({
      int? id, 
      int? position, 
      dynamic image, 
      int? category, 
      String? title, 
      int? viewtype, 
      List<ProductOptions>? productOptions,}){
    _id = id;
    _position = position;
    _image = image;
    _category = category;
    _title = title;
    _viewtype = viewtype;
    _productOptions = productOptions;
}

  Results.fromJson(dynamic json) {
    _id = json['id'];
    _position = json['position'];
    _image = json['image'];
    _category = json['category'];
    _title = json['title'];
    _viewtype = json['viewtype'];
    if (json['product_options'] != null) {
      _productOptions = [];
      json['product_options'].forEach((v) {
        _productOptions?.add(ProductOptions.fromJson(v));
      });
    }
  }
  int? _id;
  int? _position;
  dynamic _image;
  int? _category;
  String? _title;
  int? _viewtype;
  List<ProductOptions>? _productOptions;

  int? get id => _id;
  int? get position => _position;
  dynamic get image => _image;
  int? get category => _category;
  String? get title => _title;
  int? get viewtype => _viewtype;
  List<ProductOptions>? get productOptions => _productOptions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    map['image'] = _image;
    map['category'] = _category;
    map['title'] = _title;
    map['viewtype'] = _viewtype;
    if (_productOptions != null) {
      map['product_options'] = _productOptions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "ac6d987d-ead3-4990-b7e3-c64ad184cdcf"
/// image : "/media/product/circle-cropped_rVQ82Rt.png"
/// title : "(Plastic Pages) Code with Tcode studio"
/// price : 900
/// offer_price : 800

class ProductOptions {
  ProductOptions({
      String? id, 
      String? image, 
      String? title, 
      int? price, 
      int? offerPrice,}){
    _id = id;
    _image = image;
    _title = title;
    _price = price;
    _offerPrice = offerPrice;
}

  ProductOptions.fromJson(dynamic json) {
    _id = json['id'];
    _image = json['image'];
    _title = json['title'];
    _price = json['price'];
    _offerPrice = json['offer_price'];
  }
  String? _id;
  String? _image;
  String? _title;
  int? _price;
  int? _offerPrice;

  String? get id => _id;
  String? get image => _image;
  String? get title => _title;
  int? get price => _price;
  int? get offerPrice => _offerPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['image'] = _image;
    map['title'] = _title;
    map['price'] = _price;
    map['offer_price'] = _offerPrice;
    return map;
  }

}