import 'package:auto_size_text/auto_size_text.dart';
import 'package:deal/entities/image.dart';
import 'package:deal/entities/product.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/ui/common/shimmer_text.dart';
import 'package:deal/ui/item_details_ui/details_buttons.dart';
import 'package:deal/ui/item_details_ui/profile_card.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/products_webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
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
  double _distance=.0;

  List<ImageEntity> _images;

  ProductDetailsEntity _details;

  bool _isLoading = true;

  final List<_Button> _buttons = [
    _Button("Save", Icons.favorite_border, Values.primaryColor),
    _Button("Report", Icons.flag, Values.reportColor),
    _Button("Share", Icons.share, Values.shareColor)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _images = [
      ImageEntity.formJson({
        "id": 0,
        "image": widget.product.img,
        "thumb": widget.product.thumb,
        "height": "",
        "width": ""
      })
    ];

    ProductWebService().getProductDetails(widget.product.id).then((details) {
      setState(() {
        _details = details;
        _details.images.removeAt(0);
        _images.addAll(_details.images);
        _isLoading = false;
        Geolocator().distanceBetween(double.parse(AppData.Latitude), double.parse(AppData.Latitude), double.parse(_details.lat), double.parse(_details.lng)).then((distance){
          setState(() {
            _distance = distance*0.000621371;
          });
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SliverFab(
      expandedHeight: _height * .45,
      floatingWidget: FloatingActionButton(
        backgroundColor: Values.primaryColor,
        onPressed: () => print("hello"),
        child: Icon(
          FontAwesomeIcons.solidCommentAlt,
          color: Colors.white,
        ),
      ),
      floatingPosition: FloatingPosition(right: 20.0),
      slivers: <Widget>[
        SliverAppBar(
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
          flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Hero(
                      tag: "item${widget.product.id}",
                      child: Carousel(
                        height: _height * .45,
                        width: double.infinity,
                        indicatorType: "dot",
                        type: "simple",
                        axis: Axis.horizontal,
                        activeIndicatorColor: Values.primaryColor,
                        children: _images.map((img) {
                          return Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: TransitionToImage(
                              image: AdvancedNetworkImage(img.thumb,
                                  useDiskCache: true),
                              loadingWidget: Container(
                                width: double.infinity,
                                height: _height * .45,
                                color: Colors.grey,
                                child: Shimmer.fromColors(
                                    child: Container(
                                      child: Center(
                                        child: Icon(
                                          Icons.image,
                                          color: Colors.white,
                                          size: _width * .6,
                                        ),
                                      ),
                                    ),
                                    baseColor: Colors.grey.withOpacity(.4),
                                    highlightColor: Colors.white),
                              ),
                              width: double.infinity,
                              fit: BoxFit.scaleDown,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 50.0),
                        child: Container(
                          width: "\$${widget.product.price}".length * 15.0,
                          height: _height * .1,
                          padding: EdgeInsets.all(0.0),
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Image.asset(
                                  "assets/icon_price_badge.png",
                                  height: _height * .06,
                                  width:
                                      "\$${widget.product.price}".length * 15.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Center(
                                child: Text(
                                  "\$${widget.product.price}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0),
                                ),
                              )
                            ],
                          ),
                        )),
                  )
                ],
              )),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _buttons.map((btn) {
                        return DetailsButton(
                          color: btn.color,
                          text: btn.text,
                          icon: btn.icon,
                        );
                      }).toList(),
                    ),
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
        Text(
          "10-Aug-2019",
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
                          width: _width*.8,
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

  _Button(this.text, this.icon, this.color);
}
