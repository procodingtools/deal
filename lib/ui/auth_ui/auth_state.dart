import 'package:deal/ui/auth_ui/sign_tabs.dart';
import 'package:deal/ui/auth_ui/signin_form.dart';
import 'package:deal/ui/auth_ui/signup_form.dart';
import 'package:deal/ui/main_ui/main_state.dart';
import 'package:deal/utils/dimens.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final Widget route;
  final bool toSignin;
  final Function(bool status) loginStatus;

  const AuthScreen({Key key, this.route, this.toSignin, this.loginStatus})
      : super(key: key);

  createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  final double _width = Dimens.Width, _height = Dimens.Height;
  int _index = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.toSignin != null) _index = widget.toSignin ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: _width * .1,
                      left: _width * .1,
                      bottom: _height * .03),
                  child: Image.asset(
                    "assets/icon_logo.png",
                    width: _width * .15,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: _width * .1, bottom: _height * .01),
                  child: Text(
                    "Welcome back",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 25.0),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: _width * .1),
                    child: Text(
                      'Sign in to continue\nto Deal',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    )),
                Padding(
                  child: SignTabs(
                    index: _index,
                    width: _width,
                    height: _height,
                    toMain: widget.route != null && widget.route is MainScreen,
                    onFormChangedCallback: (index) {
                      setState(() {
                        _index = index;
                      });
                    },
                  ),
                  padding: EdgeInsets.only(bottom: _height * .02),
                ),
                IndexedStack(
                  index: _index,
                  children: <Widget>[
                    SigninForm(
                      width: _width,
                      height: _height,
                      result: (message, status) {
                        if (!status)
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(message),
                            ),
                            action: SnackBarAction(
                                label: "Dismiss",
                                onPressed: () {
                                  _scaffoldKey.currentState.hideCurrentSnackBar(
                                      reason: SnackBarClosedReason.dismiss);
                                }),
                          ));
                        else {
                          if (widget.route != null)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => widget.route));
                          else {
                            if (widget.loginStatus != null)
                              widget.loginStatus(true);
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                    SignupForm(
                      width: _width,
                      height: _height,
                    ),
                  ],
                ),
              ],
            ),
          )),
        ));
  }
}
