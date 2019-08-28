import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';

class MessageBar extends StatelessWidget {
  final VoidCallback onMessageSent;
  final textController;
  final bool isVisible;

  const MessageBar({
    Key key,
    this.onMessageSent,
    this.textController,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Values.primaryColor,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: isVisible
            ? Row(
                children: <Widget>[
                  _chatBtn(Icons.navigation, rotate: true),
                  _chatBtn(Icons.add_circle_outline),
                  Expanded(
                    child: _textInput(),
                  ),
                  _sendBtn(),
                ],
              )
            : Text(
                "You are no longuer continue this conversation",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
      ),
    );
  }

  Widget _chatBtn(IconData icon, {bool rotate = false}) {
    return InkWell(
      onTap: () => print('hel'),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: !rotate
            ? Icon(
                icon,
                color: Colors.white,
                size: 30.0,
              )
            : Transform.rotate(
                angle: 0.508132,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
      ),
    );
  }

  Widget _sendBtn() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: () => onMessageSent(),
          //splashColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              'Send'.toUpperCase(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }

  Widget _textInput() {
    return TextField(
      controller: textController,
      textInputAction: TextInputAction.send,
      onSubmitted: (txt) => onMessageSent(),
      decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          fillColor: Colors.white54,
          focusColor: Colors.white54,
          hoverColor: Colors.white54,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: "Type message...",
          filled: true,
          hintStyle: TextStyle(color: Colors.white)),
    );
  }
}
