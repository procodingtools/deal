import 'package:deal/entities/product.dart';
import 'package:deal/entities/user.dart';

class NotificationEntity {
  int _id;
  String _message;
  int _postId;
  ProductEntity _product;
  int _userId;
  int _fromUserId;
  UserEntity _fromUser;
  DateTime _createdAt;
  DateTime _sent;
  bool _isReview;

  NotificationEntity();

  NotificationEntity.fromJson(Map<String, dynamic> data) {
    _id = data['id'];
    _message = data['message'];
    _postId = data['post_id'];
    _product = ProductEntity(data: data['post']);
    _userId = data['user_id'];
    _fromUser = UserEntity.fromJson(data['from_user']);
    _fromUserId = data['from_user_id'];
    _createdAt = DateTime.parse(data['created_at']);
    _sent = DateTime.fromMillisecondsSinceEpoch(data['sent']);
    _isReview = data['is_review'] == 1;
  }

  bool get isReview => _isReview;

  set isReview(bool value) {
    _isReview = value;
  }

  DateTime get sent => _sent;

  set sent(DateTime value) {
    _sent = value;
  }

  DateTime get createdAt => _createdAt;

  set createdAt(DateTime value) {
    _createdAt = value;
  }

  UserEntity get fromUser => _fromUser;

  set fromUser(UserEntity value) {
    _fromUser = value;
  }

  int get fromUserId => _fromUserId;

  set fromUserId(int value) {
    _fromUserId = value;
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  ProductEntity get product => _product;

  set product(ProductEntity value) {
    _product = value;
  }

  int get postId => _postId;

  set postId(int value) {
    _postId = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}
