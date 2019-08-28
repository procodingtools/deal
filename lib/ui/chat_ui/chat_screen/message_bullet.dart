import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';

class MessageBullet extends StatelessWidget{

  final bool isMe;
  final String message;

  const MessageBullet({Key key,@required this.isMe,@required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: isMe ? Values.primaryColor : Colors.grey,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0), bottomLeft: isMe ? Radius.circular(25.0) : Radius.circular(0.0), bottomRight: !isMe ? Radius.circular(25.0) : Radius.circular(0.0))
        ),
        constraints: BoxConstraints(maxWidth: Dimens.Width*.6),
        margin: EdgeInsets.only(top: 5.0, right: 15.0, left: 15.0),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Text(message, style: TextStyle(color: Colors.white, fontSize: 15.5, fontFamily: "Gilroy"),),
      ),
    );
  }

}