/// count : 10
/// next : "http://127.0.0.1:8000/api/orders/?limit=1&offset=1"
/// previous : null
/// results : [{"id":"44bd4941-e6de-4be4-97bf-484138b11db9","title":"Code with Tcode studio","image":"/media/product/istockphoto-483960103-170667a.jpg","created_at":"2022-03-14T13:00:00+05:30","quantity":1,"status":"ORDERED","rating":0}]

class OrdersItemModel {
  OrdersItemModel({
      int? count, 
      String? next, 
      dynamic previous, 
      List<Results>? results,}){
    _count = count;
    _next = next;
    _previous = previous;
    _results = results;
}

  OrdersItemModel.fromJson(dynamic json) {
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
  String? _next;
  dynamic _previous;
  List<Results>? _results;

  int? get count => _count;
  String? get next => _next;
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

/// id : "44bd4941-e6de-4be4-97bf-484138b11db9"
/// title : "Code with Tcode studio"
/// image : "/media/product/istockphoto-483960103-170667a.jpg"
/// created_at : "2022-03-14T13:00:00+05:30"
/// quantity : 1
/// status : "ORDERED"
/// rating : 0

class Results {
  Results({
      String? id, 
      String? title, 
      String? image, 
      String? createdAt, 
      int? quantity, 
      String? status, 
      int? rating,}){
    _id = id;
    _title = title;
    _image = image;
    _createdAt = createdAt;
    _quantity = quantity;
    _status = status;
    _rating = rating;
}

  Results.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _quantity = json['quantity'];
    _status = json['status'];
    _rating = json['rating'];
  }
  String? _id;
  String? _title;
  String? _image;
  String? _createdAt;
  int? _quantity;
  String? _status;
  int? _rating;

  String? get id => _id;
  String? get title => _title;
  String? get image => _image;
  String? get createdAt => _createdAt;
  int? get quantity => _quantity;
  String? get status => _status;
  int? get rating => _rating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['quantity'] = _quantity;
    map['status'] = _status;
    map['rating'] = _rating;
    return map;
  }

}