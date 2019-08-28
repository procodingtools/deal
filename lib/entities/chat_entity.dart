import 'package:deal/entities/category.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/entities/user.dart';

class ChatEntity {
  ProductDetailsEntity _product;
  UserEntity _user;
  String _msg;
  String _type;
  bool _unread;
  DateTime _createdAt;
  bool _isBlock;
  String _randomUniquId;

  ChatEntity();

  ChatEntity.fromJson(Map<String, dynamic> data){
    _product = ProductDetailsEntity.fromJson(data["post"]);
    _user = UserEntity.fromJson(data['user']);
    _msg = data['message'];
    _type = data['type'];
    _unread = data['unread_count'] == 1;
    _createdAt = DateTime.parse(data['created_at']);
    _isBlock = data['is_block'] == 1;
    _randomUniquId = data['random_uniqu_id'];
  }

  String get randomUniquId => _randomUniquId;

  set randomUniquId(String value) {
    _randomUniquId = value;
  }

  bool get isBlock => _isBlock;

  set isBlock(bool value) {
    _isBlock = value;
  }

  DateTime get createdAt => _createdAt;

  set createdAt(DateTime value) {
    _createdAt = value;
  }

  bool get unread => _unread;

  set unread(bool value) {
    _unread = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

  UserEntity get user => _user;

  set user(UserEntity value) {
    _user = value;
  }

  ProductDetailsEntity get product => _product;

  set product(ProductDetailsEntity value) {
    _product = value;
  }


}