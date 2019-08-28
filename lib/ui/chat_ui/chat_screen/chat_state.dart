import 'package:deal/entities/chat_message.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/ui/chat_ui/chat_screen/message_bar.dart';
import 'package:deal/ui/chat_ui/chat_screen/sold_dialog.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/chat_webservice.dart';
import 'package:flutter/material.dart';

import 'message_bullet.dart';

class ChatScreen extends StatefulWidget {
  final UserEntity user;
  final ProductDetailsEntity product;

  const ChatScreen({Key key, @required this.user, @required this.product})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChatState();
  }
}

class _ChatState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  List<ChatMessageEntity> _messages = List();
  bool _isLoading = true;

  _onMessageSent() {
    if (_textController.text.isNotEmpty) {

      ChatWebService().sendMsg(widget.user.id, widget.product.id, text: _textController.text);

      _messages.add(ChatMessageEntity()
        ..message = _textController.text
        ..fromId = AppData.User.id);
      _textController.clear();

      setState(() {
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 100.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ChatWebService()
        .getChatRoom(widget.user.id, widget.product.id)
        .then((messages) {
      setState(() {
        _messages.addAll(messages);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(
            title: TextStyle(
          color: Colors.white,
          fontSize: 10.0,
        )),
        backgroundColor: Values.primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(widget.user.name),
                  Text(widget.product.title),
                ],
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
              children: <Widget>[
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: _messages.map((msg) {
                        return MessageBullet(
                          isMe: msg.fromId == AppData.User.id,
                          message: msg.message,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Center(child: widget.product.isSold ? SoldDialog() : Container()),
              ],
            )
          )),
          MessageBar(
            isVisible: !widget.product.isSold,
            textController: _textController,
            onMessageSent: _onMessageSent,
          )
        ],
      ),
    );
  }
}
