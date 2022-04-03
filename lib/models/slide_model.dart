/// position : 0
/// image : "/media/categories/tcode_DndSsba.jpg"

class SlideModel {
  SlideModel({
    int? position,
    String? image,
  }) {
    _position = position;
    _image = image;
  }

  SlideModel.fromJson(dynamic json) {
    _position = json['position'];
    _image = json['image'];
  }

  int? _position;
  String? _image;

  int? get position => _position;

  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['position'] = _position;
    map['image'] = _image;
    return map;
  }
}
