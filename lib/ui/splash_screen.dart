import 'dart:convert';
import 'dart:io';

import 'package:deal/entities/user.dart';
import 'package:deal/ui/auth_ui/auth_state.dart';
import 'package:deal/ui/lang_state.dart';
import 'package:deal/ui/main_ui/main_state.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/web_service/categories_webservice.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  var geolocator = Geolocator();
  final _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebase();
    switchScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    //getting screen size
    Dimens.Width = MediaQuery.of(context).size.width;
    Dimens.Height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/splash_bg.png"),
                  fit: BoxFit.fill,
                  repeat: ImageRepeat.noRepeat))),
    );
  }

  switchScreen(BuildContext context) async {
    Widget route;
    final futures = await Future.wait([
      _getUser(),
      _getLang(),
      _tryToGetLocation(context),
      _getCategories(),
      initFirebase(),
    ]);
    final String lang = futures[1];
    final bool isSignedIn = futures[0];
    route = lang == null ? LangScreen() : !isSignedIn ? AuthScreen(route: MainScreen(),) : MainScreen();

    if (AppData.Categories != null)
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route));
  }

  Future<String> _getLang() async {
    final sp = await SharedPreferences.getInstance();
    return await sp.getString("lang");
  }

  Future _tryToGetLocation(BuildContext context) async {
    final enabled = await Location().requestService();
    if (!enabled)
      _tryToGetLocation(context);
    else {
      final position = await geolocator.getCurrentPosition();
      AppData.Longitude = position.longitude.toString();
      AppData.Latitude = position.latitude.toString();
    }
  }

  Future _getCategories() async {
    final categories = await CategoriesWebService().getCategories();
    if (categories == null) {
      showDialog(
          context: context,
          builder: (context) => _errorCnxDialog(),
          barrierDismissible: false);
    } else {
      AppData.Categories = categories;
    }
  }

  Widget _errorCnxDialog() {
    return AlertDialog(
      content: Text("Please check your internet connection"),
      actions: <Widget>[
        FlatButton(
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            child: Text('exit')),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            _getCategories();
          },
          child: Text('ok'),
        )
      ],
    );
  }

  Future initFirebase() async {
    if (Platform.isIOS) iOS_Permission();

    AppData.FCM = await _firebaseMessaging.getToken();

    _firebaseMessaging.onTokenRefresh.listen((token) => AppData.Token = token);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
    });
  }

  Future<bool> _getUser() async {
    final sp = await SharedPreferences.getInstance();
    final usr = await sp.getString("user");
    if (usr == null)
      return false;
    UserEntity user = UserEntity.fromJson(json.decode(usr));
    AppData.User = user;
    AppData.Token = user.token;
    AppData.Headers['Authorization'] = user.token;
    return true;
  }
}
