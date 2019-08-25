class ProductEntity{
  int _id, _userId, _soldUserId;
  String _title, _price, _currSymbol, _thumb, _height, _width, _img, _desc;
  bool _isSold, _isFree, _isFav;

  ProductEntity({Map<String, dynamic> data}){
    if (data != null){
      _id = data["id"];
      _userId  = data["user_id"];
      _soldUserId = data["sold_user_id"];
      _title = data["title"];
      _price = data["price"];
      _currSymbol = data["currency_symbol"];
      _thumb = data["thumb"];
      _height = data["height"];
      _width = data["width"];
      _img = data["image"];
      _desc = data["desc"];
      _isFav = data['is_favourite'] == 1;
      _isFree = data['is_free'] == 1;
      _isSold = data['is_sold'] == 1;
    }
  }

  get isFav => _isFav;

  set isFav(value) {
    _isFav = value;
  }

  get isFree => _isFree;

  set isFree(value) {
    _isFree = value;
  }

  bool get isSold => _isSold;

  set isSold(bool value) {
    _isSold = value;
  }

  get desc => _desc;

  set desc(value) {
    _desc = value;
  }

  get img => _img;

  set img(value) {
    _img = value;
  }

  get width => _width;

  set width(value) {
    _width = value;
  }

  get height => _height;

  set height(value) {
    _height = value;
  }

  get thumb => _thumb;

  set thumb(value) {
    _thumb = value;
  }

  get currSymbol => _currSymbol;

  set currSymbol(value) {
    _currSymbol = value;
  }

  get price => _price;

  set price(value) {
    _price = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  get soldUserId => _soldUserId;

  set soldUserId(value) {
    _soldUserId = value;
  }

  get userId => _userId;

  set userId(value) {
    _userId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}