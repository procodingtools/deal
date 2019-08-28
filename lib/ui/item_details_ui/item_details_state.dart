import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_format/date_format.dart';
import 'package:deal/entities/image.dart';
import 'package:deal/entities/product.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/ui/common/shimmer_text.dart';
import 'package:deal/ui/dialogs/auth/auth_dialog.dart';
import 'package:deal/ui/item_details_ui/details_buttons.dart';
import 'package:deal/ui/common/profile_card.dart';
import 'package:deal/ui/item_details_ui/flex_bar.dart';
import 'package:deal/ui/post_ui/post_state.dart';
import 'package:deal/ui/report_ui/report_state.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/products_webservice.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliver_fab/sliver_fab.dart';

class ItemDetailsScreen extends StatefulWidget {
  final ProductEntity product;

  const ItemDetailsScreen({
    Key key,
    this.product,
  }) : super(key: key);

  createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetailsScreen> {
  final double _width = Dimens.Width, _height = Dimens.Height;
  double _distance = .0;

  bool _isMine;

  List<ImageEntity> _images;

  ProductDetailsEntity _details;

  String _saveString;
  IconData _saveIcon;

  bool _isLoading = true;

  List<_Button> _buttons;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isMine = widget.product.userId == AppData.User?.id ?? 0;
    _images = [
      ImageEntity.formJson({
        "id": 0,
        "image": widget.product.img,
        "thumb": widget.product.thumb,
        "height": "",
        "width": ""
      })
    ];

    _saveString = (_details?.isFav ?? true) ? "Save" : "Saved";
    _saveIcon =
        (_details?.isFav ?? true) ? Icons.favorite_border : Icons.favorite;

    _initBottomButtons();

    ProductWebService().getProductDetails(widget.product.id).then((details) {
      setState(() {
        _details = details;
        _details.images.removeAt(0);
        _images.addAll(_details.images);
        _isLoading = false;
        _initBottomButtons();
        Geolocator()
            .distanceBetween(
                double.parse(AppData.Latitude),
                double.parse(AppData.Latitude),
                double.parse(_details.lat),
                double.parse(_details.lng))
            .then((distance) {
          setState(() {
            _distance = distance * 0.000621371;
          });
        });
      });
    });
  }

  _initBottomButtons() {
    setState(() {
      if (_details != null) {
        _saveString = !_details.isFav ? "Save" : "Saved";
        _saveIcon = !_details.isFav ? Icons.favorite_border : Icons.favorite;
      }
      _buttons = [
        _Button(
          _saveString,
          _saveIcon,
          Values.primaryColor,
          _onSaveClicked,
        ),
        _Button(
          "Report",
          Icons.flag,
          Values.reportColor,
          () {
            if (AppData.User == null) {
              showDialog(
                  context: context,
                  builder: (context) => AuthDialog(
                        loginStatus: (status) => print(status),
                      ));
            } else
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReportScreen(
                            details: _details,
                          )));
          },
        ),
        _Button(
          "Share",
          Icons.share,
          Values.shareColor,
          () => print('hi'),
        )
      ];
    });
  }

  void _onSaveClicked() {
    if (AppData.User == null) {
      showDialog(
          context: context,
          builder: (context) => AuthDialog(
                loginStatus: (status) => print(status),
              ));
    } else if (_details != null) {
      setState(() {
        _details.isFav = !_details.isFav;
      });
      ProductWebService().saveProduct(_details.id);
      _initBottomButtons();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SliverFab(
      expandedHeight: _height * .45,
      floatingWidget: !_isMine
          ? FloatingActionButton(
              backgroundColor: Values.primaryColor,
              onPressed: () {
                if (AppData.User == null) {
                  showDialog(
                      context: context,
                      builder: (context) => AuthDialog(
                            loginStatus: (status) => print(status),
                          ));
                } else
                  print("hello");
              },
              child: Icon(
                FontAwesomeIcons.solidCommentAlt,
                color: Colors.white,
              ),
            )
          : Container(),
      floatingPosition: FloatingPosition(right: 20.0),
      slivers: <Widget>[
        SliverAppBar(
          actions: <Widget>[
            _isMine
                ? InkWell(
                    onTap: () => {
                      if (_details != null)
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostScreen(
                                        details: _details,
                                      )))
                        }
                    },
                    child: Icon(
                      Icons.create,
                      color: Values.primaryColor,
                      size: 30.0,
                    ),
                  )
                : Container()
          ],
          leading: Padding(
            padding: const EdgeInsets.all(7.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Values.primaryColor),
                width: 10.0,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          pinned: true,
          expandedHeight: _height * .45,
          floating: false,
          backgroundColor: Colors.white,
          flexibleSpace: DetailsFlexBar(
            product: widget.product,
            images: _images,
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      widget.product.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: _categoryText()),
                  Padding(
                    padding: EdgeInsets.only(bottom: 50.0),
                    child: !_isLoading
                        ? Text(
                            _details.desc,
                            style: TextStyle(color: Colors.black),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ShimmerText(width: _width * .8),
                              ShimmerText(width: _width * .5),
                              ShimmerText(width: _width * .85),
                              ShimmerText(width: _width * .2),
                            ],
                          ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: _width * .02),
                        child: DetailsProfileCard(
                          isLoading: _isLoading,
                          user: _details?.user,
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: _locationWidget()),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 150.0),
                    child: !_isMine
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _buttons.map((btn) {
                              return DetailsButton(
                                color: btn.color,
                                text: btn.text,
                                icon: btn.icon,
                                method: btn.method,
                              );
                            }).toList(),
                          )
                        : Container(),
                  )
                ],
              ),
            ),
          )
        ]))
      ],
    ));
  }

  Widget _categoryText() {
    return Row(
      children: <Widget>[
        !_isLoading
            ? Text(
                "${_details.cat.label} > ${_details.subCat.label}",
                style: TextStyle(color: Values.primaryColor),
              )
            : ShimmerText(
                width: 100.0,
                height: 15.0,
              ),
        Expanded(child: Container()),
        _isLoading
            ? ShimmerText()
            : Text(
                formatDate(_details.created, [dd, "-", M, "-", yyyy]),
                style: TextStyle(color: Colors.grey),
              )
      ],
    );
  }

  Widget _locationWidget() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: Values.primaryColor,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "${_distance.toStringAsFixed(2)} miles away",
                      style: TextStyle(color: Values.primaryColor),
                    ),
                  ),
                  !_isLoading
                      ? Container(
                          width: _width * .8,
                          child: AutoSizeText(
                            _details.location,
                            maxLines: 2,
                          ))
                      : ShimmerText(
                          width: 200.0,
                        ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _Button {
  final String text;
  final IconData icon;
  final Color color;
  final Function method;
  final isSave;

  _Button(this.text, this.icon, this.color, this.method, {this.isSave = false});
}
