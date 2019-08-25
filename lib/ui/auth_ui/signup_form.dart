import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  final double width, height;

  const SignupForm({Key key, this.width, this.height}) : super(key: key);

  createState() => _SignupState();
}

class _SignupState extends State<SignupForm> {
  final _usernameFocus = FocusNode(),
      _mailFocus = FocusNode(),
      _passwdFocus = FocusNode(),
      _rpasswdFocus = FocusNode(),
      _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: widget.height * .05),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (txt) {
                  if (txt.length < 3) return "test mail";
                  return null;
                },
                focusNode: _usernameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _usernameFocus.unfocus();
                  FocusScope.of(context).requestFocus(_mailFocus);
                },
                maxLines: 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: widget.width * .05, vertical: 10.0),
                    labelText: "Username",
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
              )),
          Padding(
              padding: EdgeInsets.only(bottom: widget.height * .05),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (txt) {
                  if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(txt)) return "test mail";
                  return null;
                },
                focusNode: _mailFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _mailFocus.unfocus();
                  FocusScope.of(context).requestFocus(_passwdFocus);
                },
                maxLines: 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: widget.width * .05, vertical: 10.0),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
              )),
          Padding(
            padding: EdgeInsets.only(bottom: widget.height * .05),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              focusNode: _passwdFocus,
              validator: (txt) {
                if (txt.length < 6) return "test passwd";
                return null;
              },
              onFieldSubmitted: (_) {
                _passwdFocus.unfocus();
                FocusScope.of(context).requestFocus(_rpasswdFocus);
              },
              maxLines: 1,
              obscureText: true,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.width * .05, vertical: 10.0),
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: widget.height * .1),
            child: TextFormField(
              keyboardType: TextInputType.text,
              focusNode: _rpasswdFocus,
              validator: (txt) {
                if (txt.length < 6) return "test passwd";
                return null;
              },
              maxLines: 1,
              obscureText: true,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.width * .05, vertical: 10.0),
                  labelText: "Confirm password",
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: widget.height*.1,
            child: RaisedButton(
              onPressed: () => print('hello'),
              textColor: Colors.white,
              color: Values.primaryColor,
              child: Text('Sign up'.toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }
}
