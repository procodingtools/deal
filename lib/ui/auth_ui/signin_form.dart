import 'package:deal/ui/auth_ui/reset_passwd_form.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/user_webservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SigninForm extends StatefulWidget {
  final double width, height;
  final Function(String message, bool success) result;

  const SigninForm({Key key, this.width, this.height, this.result}) : super(key: key);

  createState() => _SigninForm();
}

class _SigninForm extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>(),
      _emailFocus = FocusNode(),
      _passwdFocus = FocusNode();

  String _mail, _passwd;

  bool _isSigning = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        return Future.value(!_isSigning);
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: widget.height * .02),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (txt) {

                  return null;
                },
                focusNode: _emailFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _emailFocus.unfocus();
                  FocusScope.of(context).requestFocus(_passwdFocus);
                },
                onSaved: (txt){
                  _mail = txt;
                },
                maxLines: 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: widget.width * .05, vertical: 5.0),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              focusNode: _passwdFocus,
              validator: (txt) {
                if (txt.length < 6) return "test passwd";
                return null;
              },
              onSaved: (txt) => _passwd = txt,
              maxLines: 1,
              obscureText: true,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.width * .05, vertical: 5.0),
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
            ),
            Material(
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordForm())),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.width*.1, vertical: widget.height*.05),
                    child: Text("Forgot password?", style: TextStyle(color: Colors.grey),),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: widget.height*.1,
                child: RaisedButton(
                  onPressed: () {
                    if(_formKey.currentState.validate()){
                      _showLoggingInDialog();
                      _formKey.currentState.save();
                      UserWebService().login(_mail, _passwd).then((user) async {
                        _isSigning = false;
                        Navigator.of(context).pop();
                        if (user != null){
                          AppData.User = user;
                          AppData.Headers['Authorization'] = AppData.User.token;
                          final sp = await SharedPreferences.getInstance();
                          await sp.setString("user", user.toJson());
                          widget.result("Your login credential not work", true);
                        }else
                          widget.result("Your login credential not work", false);
                      });
                    }
                  },
                  textColor: Colors.white,
                  color: Values.primaryColor,
                  child: Text('Sign in'.toUpperCase()),
                  elevation: 5.0,
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: widget.height*.1,
              child: RaisedButton(
                elevation: 5.0,
                onPressed: () => _fbLogin(),
                textColor: Colors.white,
                color: Values.fbColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(FontAwesomeIcons.facebookF, color: Colors.white, size: 18.0,),
                    ),
                    Text("Facebook Login"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoggingInDialog() {
    _isSigning = true;
    showDialog(context: context,barrierDismissible: false, builder: (context){
      return WillPopScope(
        onWillPop: () {},
        child: AlertDialog(
         content: Material(
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10.0),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 CircularProgressIndicator(),
                 Padding(
                   padding: const EdgeInsets.only(left: 15.0),
                   child: Text("Logging in..."),
                 ),
               ],
             ),
           ),
         ),
        ),
      );
    });
  }

  _fbLogin() async {
    final fbLogin = FacebookLogin();
    final result = await fbLogin.logInWithReadPermissions(['email', 'public_profie', 'user_photos']);
    switch(result.status){
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken token = result.accessToken;
        AuthCredential cred = await FacebookAuthProvider.getCredential(accessToken: token.token);
        final user = await FirebaseAuth.instance.signInWithCredential(cred);
        final usr = await UserWebService().signinFacebook(user.user, token);
        AppData.User = usr;
        AppData.Token = usr.token;
        break;
      case FacebookLoginStatus.cancelledByUser:
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.error:
        // TODO: Handle this case.
        break;
    }
  }
}
