import 'dart:math';

import 'package:deal/entities/product.dart';
import 'package:deal/ui/common/shimmer_text.dart';
import 'package:deal/ui/item_details_ui/item_details_state.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/products_webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class ItemCard extends StatelessWidget {
  final bool isLoading;
  final ProductEntity product;
  final Function(bool) onSaveChanged;
  final Function() showLoginDialog;

  ItemCard(
      {Key key,
      this.isLoading,
      this.product,
      this.onSaveChanged,
      this.showLoginDialog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        if (!isLoading)
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ItemDetailsScreen(
                    product: product,
                    onSaveChanged: (isSaved) {
                      if (onSaveChanged != null) onSaveChanged(isSaved);
                    },
                  )));
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              !isLoading
                  ? Hero(
                      tag: "item${product.id}",
                      child: _heroContent(),
                    )
                  : _heroContent(),
              Container(
                width: double.infinity,
                height: 3.0,
                color: Values.primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: !isLoading
                    ? Text(
                        product.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      )
                    : ShimmerText(
                        width: Dimens.Width * .2,
                        height: Dimens.Width * .04,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        !isLoading
                            ? Text(
                                "\$${product.price}",
                                style: TextStyle(
                                    color: Values.primaryColor, fontSize: 15.0),
                              )
                            : ShimmerText(
                                width: Dimens.Width * .1,
                                height: Dimens.Width * .03,
                              ),
                      ],
                    ),
                    Expanded(child: Container()),
                    !isLoading
                        ? InkWell(
                            onTap: () {
                              if (AppData.User != null) {
                                ProductWebService().saveProduct(product.id);
                                if (onSaveChanged != null)
                                  onSaveChanged(!product.isFav);
                              } else if (showLoginDialog != null)
                                showLoginDialog();
                            },
                            child: Icon(
                              product.isFav
                                  ? FontAwesomeIcons.solidHeart
                                  : FontAwesomeIcons.heart,
                              color: Colors.pink,
                            ),
                          )
                        : Shimmer.fromColors(
                            child: Icon(
                              FontAwesomeIcons.solidHeart,
                              color: Colors.grey,
                            ),
                            baseColor: Colors.grey.withOpacity(.4),
                            highlightColor: Colors.white)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroContent() {
    return Stack(
      children: <Widget>[
        !isLoading
            ? TransitionToImage(
                image: AdvancedNetworkImage(product.thumb,
                    useDiskCache: true,
                    cacheRule: CacheRule(maxAge: Duration(days: 10))),
                placeholder: Container(
                  height: 100.0 + Random().nextDouble(),
                  child: Image.asset(
                    "assets/icon_no_image.png",
                    fit: BoxFit.cover,
                    width: 500.0,
                    height: 500.0,
                  ),
                ),
                loadingWidget: Container(
                  height: 100.0 + Random().nextDouble(),
                  child: Image.asset(
                    "assets/icon_no_image.png",
                    fit: BoxFit.cover,
                    width: 500.0,
                    height: 500.0,
                  ),
                ),
                repeat: ImageRepeat.noRepeat,
                //borderRadius: BorderRadius.circular(500.0),
              )
            : Container(
                height: 80.0 + Random().nextInt(150 - 80),
                child: Shimmer.fromColors(
                    child: Container(
                      color: Colors.grey,
                    ),
                    baseColor: Colors.grey.withOpacity(.4),
                    highlightColor: Colors.white),
              ),
        Align(
          alignment: Alignment.topLeft,
          child: product?.isSold ?? false
              ? Image.asset(
                  "assets/icon_sold.png",
                  height: 55.0,
                )
              : product?.isFree ?? false
                  ? Image.asset(
                      "assets/icon_free.png",
                      height: 55.0,
                    )
                  : Container(),
        )
      ],
    );
  }
}
