import 'package:deal/entities/image.dart';
import 'package:deal/entities/product.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:shimmer/shimmer.dart';

class DetailsFlexBar extends StatelessWidget{
  
  final ProductEntity product;
  final List<ImageEntity> images;

  const DetailsFlexBar({Key key,@required this.product,@required this.images,}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Hero(
                  tag: "item${product.id}",
                  child: Stack(
                    children: <Widget>[
                      Carousel(
                        height: Dimens.Height * .45,
                        width: double.infinity,
                        indicatorType: "dot",
                        type: "simple",
                        axis: Axis.horizontal,
                        activeIndicatorColor: Values.primaryColor,
                        children: images.map((img) {
                          return TransitionToImage(
                            image: AdvancedNetworkImage(img.thumb,
                                useDiskCache: true),
                            loadingWidget: Container(
                              width: double.infinity,
                              height: Dimens.Height * .45,
                              color: Colors.grey,
                              child: Shimmer.fromColors(
                                  child: Container(
                                    child: Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.white,
                                        size: Dimens.Width * .6,
                                      ),
                                    ),
                                  ),
                                  baseColor: Colors.grey.withOpacity(.4),
                                  highlightColor: Colors.white),
                            ),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        }).toList(),
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
                            : Container(height: .0,),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 50.0),
                    child: Container(
                      width: "\$${product.price}".length * 15.0,
                      height: Dimens.Height * .1,
                      padding: EdgeInsets.all(0.0),
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Image.asset(
                              "assets/icon_price_badge.png",
                              height: Dimens.Height * .06,
                              width:
                              "\$${product.price}".length * 15.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Center(
                            child: Text(
                              "\$${product.price}",
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
    );
  }
  
}