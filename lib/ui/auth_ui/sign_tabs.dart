import 'package:deal/ui/main_ui/main_state.dart';
import 'package:flutter/material.dart';

typedef VoidCallback FormChanges(int index);

class SignTabs extends StatefulWidget {
  final width, height;
  final FormChanges onFormChangedCallback;
  final bool toMain;
  final int index;

  const SignTabs({
    Key key,
    this.width,
    this.height,
    this.onFormChangedCallback,
    this.toMain, @required this.index,
  }) : super(key: key);

  createState() => _SignState();
}

class _SignState extends State<SignTabs> {
  int index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: widget.height * .05, horizontal: widget.width * .1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _tabBtn("Sign in", 0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.width * .05),
            child:
                Text("/", style: TextStyle(fontSize: 15.0, color: Colors.grey)),
          ),
          _tabBtn("Sing up", 1),
          Expanded(child: Container()),
          FlatButton(
            onPressed: () {
              if (widget.toMain)
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainScreen()));
              else
                Navigator.pop(context);
            },
            child: Row(
              children: <Widget>[
                Text('Skip',
                    style: TextStyle(fontSize: 13.0, color: Color(0xff4CC17B))),
                Icon(
                  Icons.arrow_forward,
                  color: Color(0xff4CC17B),
                  size: 13.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _tabBtn(String text, int i){
    return InkWell(
        onTap: () {
          setState(() {
            index = i;
            widget.onFormChangedCallback(index);
          });
        },
        child: Text(text,
            style: TextStyle(
                fontSize: 15.0,
                color: index == i ? Colors.black : Colors.grey,
                fontWeight:
                index == i ? FontWeight.bold : FontWeight.normal)));
  }

}
