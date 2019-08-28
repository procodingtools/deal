import 'package:flutter/material.dart';

class DetailsButton extends StatelessWidget{

  final Color color;
  final String text;
  final IconData icon;
  final Function method;

  const DetailsButton({Key key, this.color, this.text, this.icon, this.method,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RaisedButton(
      onPressed: method,
      splashColor: Colors.white54,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                icon,
                size: 17.0,
                color: Colors.white,
              ),
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(150.0)),
    );
  }

}