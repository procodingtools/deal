import 'package:deal/entities/category.dart';

class PostEntity{
  String _title;
  String _description;
  double _price;
  CategoryEntity _cat;
  String _adr;
  String _country;
  String _state;
  String _city;

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  String get country => _country;

  set country(String value) {
    _country = value;
  }

  String get adr => _adr;

  set adr(String value) {
    _adr = value;
  }

  CategoryEntity get cat => _cat;

  set cat(CategoryEntity value) {
    _cat = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }


}