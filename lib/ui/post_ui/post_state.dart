import 'package:deal/entities/category.dart';
import 'package:deal/ui/categories_ui/categories_state.dart';
import 'package:deal/ui/location_picker/location_picker_state.dart';
import 'package:deal/ui/post_ui/photo_list.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class PostScreen extends StatefulWidget {
  createState() => _PostState();
}

class _PostState extends State<PostScreen> {
  final _width = Dimens.Width, _height = Dimens.Height;
  final _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode(),
      _descFocusNode = FocusNode(),
      _priceFocusNode = FocusNode();
  String _title, _desc, _price, _adr, _country, _state, _city;
  double _lat, _lng;
  CategoryEntity _cat;

  setOnCategoryListener(CategoryEntity category) =>
      setState(() => _cat = category);

  _setOnLocationListener(LocationResult location){
    _country = "Country";
    _state = "State";
    _city = "City";
    _lat = location.latLng.latitude;
    _lng = location.latLng.longitude;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _country = "Country";
    _state = "State";
    _city = "City";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Values.primaryColor,
        title: Text("Post"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PhotosList(),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //title text
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      decoration: Values.TextFieldDecoration('Title'),
                      focusNode: _titleFocusNode,
                      textInputAction: TextInputAction.next,
                      validator: (txt) {
                        return txt.length < 3
                            ? "Please fill with a valid title"
                            : null;
                      },
                      onSaved: (txt) => _title = txt,
                      onFieldSubmitted: (term) {
                        _titleFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      maxLines: 1,
                    ),
                  ),

                  //description text
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      decoration: Values.TextFieldDecoration("Description"),
                      focusNode: _descFocusNode,
                      textInputAction: TextInputAction.next,
                      validator: (txt) {
                        return txt.length < 5
                            ? "Please fill with a valid description"
                            : null;
                      },
                      maxLines: 2,
                      onSaved: (txt) => _desc = txt,
                      onFieldSubmitted: (term) {
                        _descFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                    ),
                  ),

                  //price text
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      decoration: Values.TextFieldDecoration("Price"),
                      keyboardType:
                          TextInputType.numberWithOptions(signed: false),
                      focusNode: _priceFocusNode,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      validator: (txt) {
                        return txt.isEmpty
                            ? "Please fill with a valid price"
                            : txt != "Free"
                                ? double.parse(txt) <= 0
                                    ? "Please fill with a valid price"
                                    : null
                                : "Please fill with a valid price";
                      },
                      onSaved: (txt) => _price = txt,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 50.0,
                  bottom: 20.0,
                  left: _width * .05,
                  right: _width * .05),
              child: Column(
                children: <Widget>[
                  _button(
                      title: _cat == null
                          ? "Category"
                          : "${_cat.label}${_cat.subCategory == null || _cat.subCategory.isEmpty ? "" : " > " + _cat.subCategory[0].label}",
                      navigateTo: CategoriesScreen(catgoryCallback: setOnCategoryListener,)),
                  _button(title: "Location", navigateTo: LocationPickerScreen(onLocationChanged: _setOnLocationListener,)),
                  _button(
                    title: _country,
                  ),
                  _button(
                    title: _state,
                  ),
                  _button(
                    title: _city,
                  ),
                ],
              ),
            ),
            _postBtn()
          ],
        ),
      ),
    );
  }

  Widget _button({String title, Widget navigateTo}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.0),
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: .0,
        onPressed: () {
          if (navigateTo != null)
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => navigateTo));
          else
            return Navigator.push(context, MaterialPageRoute(builder: (context) => navigateTo));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              navigateTo != null
                  ? Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 15.0,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _postBtn() {
    return MaterialButton(
      onPressed: () {
        _formKey.currentState.validate();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          "Post".toUpperCase(),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
        ),
      ),
      color: Values.primaryColor,
      minWidth: _width,
    );
  }
}
