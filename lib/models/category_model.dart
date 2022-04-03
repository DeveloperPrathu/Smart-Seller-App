class CategoryModel {

  dynamic id;
  String? name,image;
  int? position;

  CategoryModel(this.id,this.name, this.image, this.position);

  CategoryModel.fromJson(dynamic json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
    position = json['position'];
  }

  Map<String,dynamic> toJson(){
    var map = <String,dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['position'] = position;
    return map;
  }
}