import 'dart:io';

import 'package:deal/entities/category.dart';
import 'package:deal/entities/image.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/ui/categories_ui/categories_state.dart';
import 'package:deal/ui/location_picker/location_picker_state.dart';
import 'package:deal/ui/post_ui/photo_list.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/products_webservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:path_provider/path_provider.dart';

class PostScreen extends StatefulWidget {
  final ProductDetailsEntity details;
  final Function onProductAdded;

  const PostScreen({Key key, this.details, this.onProductAdded}) : super(key: key);

  createState() => _PostState();
}

class _PostState extends State<PostScreen> {

  final _width = Dimens.Width,
      _height = Dimens.Height;
  final _formKey = GlobalKey<FormState>(),
      _scaffoldKey = GlobalKey<ScaffoldState>();
  final _titleFocusNode = FocusNode(),
      _descFocusNode = FocusNode(),
      _priceFocusNode = FocusNode();
  String _title, _desc, _price, _adr, _country, _state, _city, _location;
  double _lat, _lng;
  CategoryEntity _cat, _subCat;

  TextEditingController _titleController, _descriptionController, _priceController;

  bool _isUploading = false;

  List<Map<String, dynamic>> _photos = List();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _country = "Country";
    _state = "State";
    _city = "City";
    _location = "Location";
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();

    if (widget.details != null) {
      _country = widget.details.country;
      _city = widget.details.city;
      _state = widget.details.state;
      _titleController.text = widget.details.title;
      _descriptionController.text = widget.details.desc;
      _priceController.text = widget.details.price;

      getTemporaryDirectory().then((dir) {
        String tmpDir = dir.path;
        _fetchPhotos(tmpDir);
      });
    }
  }

  _setOnCategoryListener(CategoryEntity category, CategoryEntity subCat) =>
      setState(() {
        _cat = category;
        _subCat = subCat;
      });

  _setOnLocationListener(LocationResult location) {
    _country = "Country";
    _state = "State";
    _city = "Country";
    _location = "Location";
    _lat = location.latLng.latitude;
    _lng = location.latLng.longitude;
    _state = location.state ?? location.city ?? "State";
    _city = location.city ?? "City";
    _country = location.country ?? "Country";
    _location = location.formattedAdr ?? 'Location';
  }

  _setOnPhotosListener(List<Map<String, dynamic>> photos) {
    setState(() {
      _photos
        ..clear()
        ..addAll(photos);
    });
  }

_fetchPhotos(String tmpDir) async {
  for(final img in widget.details.images) {
    String path = "$tmpDir/${img.thumb.substring(img.thumb.lastIndexOf('/') + 1)}";
    final request = await HttpClient().getUrl(Uri.parse(img.thumb));
    final response = await request.close();
    await response.pipe(new File(path).openWrite());
    _photos.add({'path': path});
  };
  setState(() {
  });
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  return Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      backgroundColor: Values.primaryColor,
      title: Text("Post"),
    ),
    body: WillPopScope(
      onWillPop: () =>
      _isUploading ? Future.value(false) : Future.value(true),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PhotosList(
              onPhotosChanged: _setOnPhotosListener,
              photos: _photos,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //title text
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: _titleController,
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
                      controller: _descriptionController,
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
                      controller: _priceController,
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
                          : "${_cat.label}${_subCat == null ? "" : " > " +
                          _subCat.label}",
                      navigateTo: CategoriesScreen(
                        catgoryCallback: _setOnCategoryListener,
                      )),
                  _button(
                      title: _location,
                      navigateTo: LocationPickerScreen(
                        onLocationChanged: _setOnLocationListener,
                      )),
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
          return Navigator.push(
              context, MaterialPageRoute(builder: (context) => navigateTo));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: _width * .7,
              child: Text(
                title ?? "",
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
      if (_cat == null)
        _scaffoldKey.currentState
            .showSnackBar(_snackBar("Please select category"));
      else if (_location == 'Location')
        _scaffoldKey.currentState
            .showSnackBar(_snackBar("Please select location"));

      if (!_isUploading &&
          _formKey.currentState.validate() &&
          _cat != null &&
          _location != "Location") {
        setState(() {
          _isUploading = true;
        });
        _formKey.currentState.save();
        ProductDetailsEntity product = ProductDetailsEntity();
        product.subCat = _subCat;
        product.cat = _cat;
        product.title = _title;
        product.desc = _desc;
        product.images = _photos.map((photo) {
          return ImageEntity()
            ..img = photo['path'];
        }).toList();
        product.price = _price;
        product.lat = _lat.toString();
        product.lng = _lng.toString();
        product.location = _location;
        product.city = _city == 'City' ? "" : _city;
        product.country = _country == 'Country' ? "" : _country;
        product.state = _state == "State" ? "" : _country;

        ProductWebService().postProduct(product).then((val) {
          print(val);
          setState(() {
            _isUploading = false;
            if (widget.onProductAdded != null)
              widget.onProductAdded();
            Navigator.pop(context);
          });
        });
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: _isUploading
          ? Theme(
          data: ThemeData(accentColor: Colors.white),
          child: CircularProgressIndicator())
          : Text(
        "Post".toUpperCase(),
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.0),
      ),
    ),
    color: Values.primaryColor,
    minWidth: _width,
  );
}

SnackBar _snackBar(String text) {
  return SnackBar(
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(text),
    ),
    action: SnackBarAction(
      label: "Dismiss",
      onPressed: () => _scaffoldKey.currentState.hideCurrentSnackBar(),
    ),
  );
}}
