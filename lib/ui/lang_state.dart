import 'package:deal/ui/auth_ui/auth_state.dart';
import 'package:deal/ui/main_ui/main_state.dart';
import 'package:deal/utils/dimens.dart';
import 'package:flutter/material.dart';
//import "dart:ui" show Color;

class LangScreen extends StatefulWidget {
  createState() => _LangState();
}

class _LangState extends State<LangScreen> {

  List<String> _lang = List();
  final _width = Dimens.Width;
  final _height = Dimens.Height;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lang.add("English");
    _lang.add("عربي");
    _lang.add("Espagñol");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff4CC17B),
          centerTitle: true,
          title: Text("Select Language"),
        ),
        body: SafeArea(
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
                    padding: EdgeInsets.all(_width*.1),
                    child: Image.asset("assets/icon_logo.png", width: _width*.15,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: _width*.1, bottom: _width*.05),
                    child: Text("Welcome there", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25.0),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: _width*.1, bottom: _height*.1),
                    child: Text('Select your prefered\nlanguage to continue', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ),
                  _buildLang()
                ],
              ),
            )));
  }

  Widget _buildLang() {
    int i = -1;
    return DecoratedBox(
      decoration: BoxDecoration(border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(.5)),
          bottom: BorderSide(color: Colors.grey.withOpacity(.5)))),
      child: Column(
          children: _lang.map((lang) {
            i++;
            return InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthScreen(route: MainScreen(),)));
              },
              child: i == 1 ? DecoratedBox(decoration: BoxDecoration(border: Border(
                  top: BorderSide(color: Colors.grey.withOpacity(.5)),
                  bottom: BorderSide(color: Colors.grey.withOpacity(.5)))), child: _langText(lang),) : _langText(lang)
            );
          }).toList()
      ),
    );
  }

  Widget _langText(String lang){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0), child: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 20.0), child: Text(lang, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),),
        Expanded(child: Container()),
        Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Icon(Icons.arrow_forward, size: 17.0,),
        ),
      ],
    ),);
  }
}
