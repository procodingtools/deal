import 'package:deal/ui/auth_ui/auth_state.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthDialog extends StatelessWidget {

  final Function(bool status) loginStatus;

  const AuthDialog({Key key,@required this.loginStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      content: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
              elevation: 5.0,
              onPressed: () => print('hello'),
              textColor: Colors.white,
              color: Values.fbColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.white,
                        size: 18.0,
                      ),
                    ),
                    Text("Continue with Facebook",),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Or use your email address",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: RaisedButton(onPressed: () => _authenticate(context), child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                ))),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                Expanded(child: RaisedButton(onPressed: () => _authenticate(context, toSignin: false), child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                ),)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: RichText(
                  text:
                      TextSpan(text: "By using this app you agree to\n", children: [
                TextSpan(
                    text: "Terms of service",
                    style: TextStyle(
                        color: Values.primaryColor,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => print('Hello mod')),
                TextSpan(
                  text: " and ",
                ),
                TextSpan(
                    text: "privacy policy",
                    style: TextStyle(
                        color: Values.primaryColor,
                        decoration: TextDecoration.underline)),
              ], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    );
  }

  _authenticate(BuildContext context, {bool toSignin}) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen(toSignin: toSignin, loginStatus: loginStatus,)));
  }
}
