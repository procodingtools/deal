import 'package:deal/utils/dimens.dart';
import 'package:flutter/material.dart';

class Values{
  //Colors
  static Color primaryColor = Color(0xff4CC17B);
  static Color fbColor = Color(0xff3b5998);
  static Color ratingColor = Color(0xfffeb527);
  static Color reportColor = Color(0xffe53935);
  static Color shareColor = Color(0xff6751f3);
  static Color iconsColor = Color(0xff494b51);

  static InputDecoration TextFieldDecoration(String label){
    return InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(
            horizontal: Dimens.Width * .05, vertical: 5.0),
        labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)));
  }
}