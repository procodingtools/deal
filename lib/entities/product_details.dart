import 'package:deal/entities/category.dart';
import 'package:deal/entities/image.dart';
import 'package:deal/entities/user.dart';

class ProductDetailsEntity {
  int _id, _categoryId, _userId, _soldToUser, _subCategory;
  String _title,
      _desc,
      _price,
      _currSymbol,
      _location,
      _lat,
      _lng,
      _country,
      _state,
      _city;
  DateTime _created, _updated;
  bool _isSold, _isFree, _isFav;
  CategoryEntity _cat;
  CategoryEntity _subCat;
  List<ImageEntity> _images;
  UserEntity _user;
  String _img;
  String _thumb;

  ProductDetailsEntity();

  ProductDetailsEntity.fromJson(Map<String, dynamic> data) {
    _id = data['id'];
    _categoryId = data['category_id'] ?? null;
    _userId = data['user_id'] ?? null;
    _soldToUser = data['sold_user_id'] ?? null;
    _subCategory = data['sub_category_id'] ?? null;
    _title = data['title'] ?? null;
    _desc = data['desc'] ?? null;
    _price = data['price'] ?? null;
    _currSymbol = data['currency_symbol'] ?? null;
    _location = data['location'] ?? null;
    _lat = data['latitude'] ?? null;
    _lng = data['longitude'] ?? null;
    _country = data['country'] ?? null;
    _state = data['sstate'] ?? null;
    _city = data['city'] ?? null;
    _created = DateTime.parse(data['created_at'] ?? DateTime.now().toString());
    _updated = DateTime.parse(data['updated_at'] ?? DateTime.now().toString());
    _isSold = data['is_sold'] == 1;
    _isFree = data['is_free'] == 1;
    _isFav = data['is_favourite'] == 1;
    _cat = CategoryEntity(data: data['category'] ?? null);
    _subCat = CategoryEntity(data: data['sub_category'] ?? null);
    _user = data.containsKey("user") ? UserEntity.fromJson(data['user']) : null;
    _images = List();
    if (data.containsKey('images'))
      for (final img in data['images'])
        images.add(ImageEntity.formJson(img) ?? null);
    _img = data['image'] ?? null;
    _thumb = data['thumb'] ?? null;
  }

  UserEntity get user => _user;

  set user(UserEntity value) {
    _user = value;
  }

  String get img => _img;

  set img(String value) {
    _img = value;
  }

  List<ImageEntity> get images => _images;

  set images(List<ImageEntity> value) {
    _images = value;
  }

  CategoryEntity get cat => _cat;

  set cat(CategoryEntity value) {
    _cat = value;
  }

  CategoryEntity get subCat => _subCat;

  set subCat(value) {
    _subCat = value;
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

  get updated => _updated;

  set updated(value) {
    _updated = value;
  }

  DateTime get created => _created;

  set created(DateTime value) {
    _created = value;
  }

  get city => _city;

  set city(value) {
    _city = value;
  }

  get state => _state;

  set state(value) {
    _state = value;
  }

  get country => _country;

  set country(value) {
    _country = value;
  }

  get lng => _lng;

  set lng(value) {
    _lng = value;
  }

  get lat => _lat;

  set lat(value) {
    _lat = value;
  }

  get location => _location;

  set location(value) {
    _location = value;
  }

  get currSymbol => _currSymbol;

  set currSymbol(value) {
    _currSymbol = value;
  }

  get price => _price;

  set price(value) {
    _price = value;
  }

  get desc => _desc;

  set desc(value) {
    _desc = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  get subCategory => _subCategory;

  set subCategory(value) {
    _subCategory = value;
  }

  get soldToUser => _soldToUser;

  set soldToUser(value) {
    _soldToUser = value;
  }

  get userId => _userId;

  set userId(value) {
    _userId = value;
  }

  get categoryId => _categoryId;

  set categoryId(value) {
    _categoryId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get thumb => _thumb;

  set thumb(String value) {
    _thumb = value;
  }


}
