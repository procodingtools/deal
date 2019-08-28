class ChatMessageEntity {
  String _message;
  int _id, _fromId, _toId, _sent;

  ChatMessageEntity();

  ChatMessageEntity.fromJson(Map<String, dynamic> data){
    _id = data['id'];
    _message = data['message'];
    _fromId = data['from_id'];
    _toId = data['to_id'];
    _sent = data['sent'];
  }

  get sent => _sent;

  set sent(value) {
    _sent = value;
  }

  get toId => _toId;

  set toId(value) {
    _toId = value;
  }

  get fromId => _fromId;

  set fromId(value) {
    _fromId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }


}