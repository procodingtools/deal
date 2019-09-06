import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/user_webservice.dart';
import 'package:flutter/material.dart';

class ResetPasswordForm extends StatefulWidget {
  createState() => _ResetPasswdState();
}

class _ResetPasswdState extends State<ResetPasswordForm> {

  String _email;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Image.asset("assets/icon_login_logo.png", width: Dimens.Width*.7, height: 100,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal:20.0),
            child: Text(
              "Please enter your email address and we will send you forgot password link!!!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "Gilroy"),
            ),
          ),

          TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (txt){
              _email = txt;
            },
            maxLines: 1,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimens.Width * .05, vertical: 5.0),
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey))),
          ),


          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: MaterialButton(onPressed: () {
              if(RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
                UserWebService().resetPasswd(_email).then((result){
                  Navigator.pop(context);
                });
              }
            },
              child: Text("Send".toUpperCase()),
              color: Values.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
            ),
          ),
        ],
      ),
    );
  }
}
