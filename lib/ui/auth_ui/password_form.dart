import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/user_webservice.dart';
import 'package:flutter/material.dart';

class PasswordForm extends StatefulWidget {
  createState() => _PasswdState();
}

class _PasswdState extends State<PasswordForm>{
  String _current, _new, _retype;
  final _formKey = GlobalKey<FormState>();
  final _currentFocusNode = FocusNode(),
      _newFocusNode = FocusNode(),
      _retypeFocusNode = FocusNode();
  final _newController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Values.primaryColor,
        title: Text('Change password'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  focusNode: _currentFocusNode,
                  validator: (txt) {
                    if (txt.length < 6) return "check password";
                    return null;
                  },
                  onFieldSubmitted: (term) {
                    _currentFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_newFocusNode);
                  },
                  onSaved: (txt) => _current = txt,
                  maxLines: 1,
                  obscureText: true,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Dimens.Width * .05, vertical: 5.0),
                      labelText: "Current password",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  controller: _newController,
                  keyboardType: TextInputType.text,
                  focusNode: _newFocusNode,
                  validator: (txt) {
                    if (txt.length < 6) return "check password";
                    return null;
                  },
                  onFieldSubmitted: (term) {
                    _newFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_retypeFocusNode);
                  },
                  onSaved: (txt) => _new = txt,
                  maxLines: 1,
                  obscureText: true,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Dimens.Width * .05, vertical: 5.0),
                      labelText: "New password",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                  textInputAction: TextInputAction.next,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  focusNode: _retypeFocusNode,
                  validator: (txt) {
                    if (txt.length < 6) return "check password";
                    if (txt != _newController.text) return "password mismatch";
                    return null;
                  },
                  onSaved: (txt) => _retype = txt,
                  maxLines: 1,
                  obscureText: true,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Dimens.Width * .05, vertical: 5.0),
                      labelText: "Confirm password",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 17.0),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0),
                child: MaterialButton(onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    UserWebService().updatePasswd(_current, _new).then((res) {
                      if (!res) {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text("Check your current password"),
                              action: SnackBarAction(label: "Dismiss",
                                  onPressed: () =>
                                      _scaffoldKey.currentState
                                          .hideCurrentSnackBar()),));
                      } else
                        Navigator.pop(context);
                    });
                  }
                },
                  child: Text("Change".toUpperCase()),
                  color: Values.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}