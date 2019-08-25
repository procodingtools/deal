import 'package:deal/utils/appdata.dart';

class UserEntity {
  int _id;
  double _rating;
  String _name, _email, _thumb;

  String _status = "";
  String _message = "";
  String _userId = "";
  String _fbId = "";
  String _fullName = "";
  String _mobile = "";
  String _profilePicThumb = "";
  String _profilePicOriginal = "";
  String _latitude = "";
  String _longitude = "";
  String _token = "";
  List<String> _searchHistory = new List();

  UserEntity({Map<String, dynamic> data}) {
    if (data != null) {
      _id = data['id'];
      _name = data['name'];
      _email = data['email'];
      _mobile = data['mobile_no'];
      _profilePicThumb = data['profile_thumb'];
      _profilePicOriginal = data['profile'];
      _rating = data['ratting']+.0;
      //_searchHistory = data['search_history'];
      _token = "Bearer " + data['token'];
      AppData.Toekn = _token;
    }
  }

  UserEntity.fromJson(Map<String, dynamic> data)
      : _id = data['id'],
        _name = data['name'],
        _email = data['email'],
        _thumb = data['profile_thumb'],
        _rating = data['ratting'] + .0;

  get thumb => _thumb;

  set thumb(value) {
    _thumb = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  List<String> get searchHistory => _searchHistory;

  set searchHistory(List<String> value) {
    _searchHistory = value;
  }

  String get token => _token;

  set token(String value) {
    _token = value;
  }

  String get longitude => _longitude;

  set longitude(String value) {
    _longitude = value;
  }

  String get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
  }

  String get profilePicOriginal => _profilePicOriginal;

  set profilePicOriginal(String value) {
    _profilePicOriginal = value;
  }

  String get profilePicThumb => _profilePicThumb;

  set profilePicThumb(String value) {
    _profilePicThumb = value;
  }

  String get mobile => _mobile;

  set mobile(String value) {
    _mobile = value;
  }

  String get fullName => _fullName;

  set fullName(String value) {
    _fullName = value;
  }

  String get fbId => _fbId;

  set fbId(String value) {
    _fbId = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }


}
