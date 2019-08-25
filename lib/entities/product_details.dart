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

  ProductDetailsEntity.fromJson(Map<String, dynamic> data){
        _id = data['id'];
        _categoryId = data['category_id'];
        _userId = data['user_id'];
        _soldToUser = data['sold_user_id'];
        _subCategory = data['sub_category_id'];
        _title = data['title'];
        _desc = data['desc'];
        _price = data['price'];
        _currSymbol = data['currency_symbol'];
        _location = data['location'];
        _lat = data['latitude'];
        _lng = data['longitude'];
        _country = data['country'];
        _state = data['sstate'];
        _city = data['city'];
        _created = DateTime.parse(data['created_at']);
        _updated = DateTime.parse(data['updated_at']);
        _isSold = data['is_sold'] == 1;
        _isFree = data['is_free'] == 1;
        _isFav = data['is_favourite'] == 1;
        _cat = CategoryEntity(data: data['category']);
        _subCat = CategoryEntity(data: data['sub_category']);
        _user = UserEntity.fromJson(data['user']);
        _images = List();
        for (final img in data['images'])
          images.add(ImageEntity.formJson(img));
      }




  UserEntity get user => _user;

  set user(UserEntity value) {
    _user = value;
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


}
