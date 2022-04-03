class UserModel{

  String? email;
  String? phone;
  String? fullname;
  List<String>? wishlist;
  List<String>? cart;
  int? notifications;

  String? name;
  String? address;
  int? pincode;
  String? contact_no;
  String? state;
  String? district;

  UserModel(this.email,this.notifications, this.phone, this.fullname,this.wishlist,this.cart,this.name,this.address,this.contact_no,this.pincode);

  UserModel.fromJson(dynamic json){
    email = json['email'];
    phone = json['phone'];
    fullname = json['fullname'];
    notifications = json['notifications'];

    name = json['name'];
    address = json['address'];
    contact_no = json['contact_no'];
    pincode = json['pincode'];
    state = json['state'];
    district = json['district'];

    if (json['wishlist'] != null) {
      wishlist = [];
      json['wishlist'].forEach((v) {
        wishlist?.add(v);
      });
    }
    if (json['cart'] != null) {
      cart = [];
      json['cart'].forEach((v) {
        cart?.add(v);
      });
    }

  }

  Map<String,dynamic> toJson(){
    var map = <String,dynamic>{};
    map['email'] = email;
    map['phone'] = phone;
    map['fullname'] = fullname;
    map['notifications'] = notifications;

    map['name'] = name;
    map['address'] = address;
    map['pincode'] = pincode;
    map['contact_no'] = contact_no;
    map['state'] = state;
    map['district'] = district;
    if (wishlist != null) {
      map['wishlist'] = wishlist?.map((v) => v).toList();
    }
    if (cart != null) {
      map['cart'] = cart?.map((v) => v).toList();
    }
    return map;
  }
}