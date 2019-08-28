class ImageEntity {
  int _id;
  String _img, _thumb;
  double _height, _width;

  ImageEntity();

  ImageEntity.formJson(Map<String, dynamic> data) {
    _id = data['id'];
    _img = data['image'];
    _thumb = data['thumb'];
    try {
      _width = double.parse(data['width']);
    } catch (e) {
      _width = .0;
    };
    try {
      _height = double.parse(data['height']);
    } catch (e) {
      _height = .0;
    }
  }

  get width => _width;

  set width(value) {
    _width = value;
  }

  double get height => _height;

  set height(double value) {
    _height = value;
  }

  get thumb => _thumb;

  set thumb(value) {
    _thumb = value;
  }

  String get img => _img;

  set img(String value) {
    _img = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
