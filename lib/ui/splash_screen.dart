import 'package:deal/ui/lang_state.dart';
import 'package:deal/ui/main_ui/main_state.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/web_service/categories_webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  createState() => _SplashState();
}

class _SplashState extends State<SplashScreen>{

  var geolocator = Geolocator();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  switchScreen(BuildContext context) {
    SharedPreferences.getInstance().then((langPref) {
      var lang = langPref.getString("lang");
      Widget route;
      route = lang == null ? LangScreen() : MainScreen();
      _tryToGetLocation(context);
    });
  }

  _tryToGetLocation(BuildContext context){
    Location().requestService().then((enabled){
      if(!enabled)
        _tryToGetLocation(context);
      else{
        geolocator.getCurrentPosition().then((position){
          AppData.Longitude = position.longitude.toString();
          AppData.Latitude = position.latitude.toString();
          _getCategories();
        });
      }
    });

  }

  void _getCategories() {
    CategoriesWebService()
      ..getCategories().then((categories) {
        if (categories == null){
         showDialog(context: context,builder: (context) => _errorCnxDialog(), barrierDismissible: false);
        }else {
          AppData.Categories = categories;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LangScreen()));
        }
      });
  }

  Widget _errorCnxDialog() {
    return AlertDialog(content: Text("Please check your internet connection"), actions: <Widget>[
      FlatButton(onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'), child: Text('exit')),
      FlatButton(onPressed: () {
        Navigator.pop(context);
        _getCategories();
      }, child: Text('ok'),)
    ],);
  }
}
