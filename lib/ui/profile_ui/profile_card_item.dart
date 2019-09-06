import 'package:deal/entities/product.dart';
import 'package:deal/ui/common/shimmer_text.dart';
import 'package:deal/ui/item_details_ui/item_details_state.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import 'delete_button.dart';

class ProfileCardItem extends StatelessWidget{
  final ProductEntity product;
  final bool isMine;
  final Function() onDeleteProduct;

  const ProfileCardItem({Key key, this.product, this.isMine = false, this.onDeleteProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0),
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemDetailsScreen(
                      product: product,
                    ))),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        TransitionToImage(
                          image: AdvancedNetworkImage(product.thumb,
                              useDiskCache: true,
                              cacheRule: CacheRule(maxAge: Duration(days: 10))),
                          placeholder: ShimmerText(
                            height: 70.0,
                            width: 70.0,
                          ),
                          loadingWidget: Image.asset("assets/icon_no_image.png"),
                          repeat: ImageRepeat.noRepeat,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                          //borderRadius: BorderRadius.circular(500.0),
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
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 3.0,
                    color: Values.primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text(
                      "${product.title}",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "\$${product.price}",
                              style: TextStyle(
                                  color: Values.primaryColor, fontSize: 15.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        isMine && !product.isSold ? DeleteButton(product: product, onProductDelete: onDeleteProduct,) : Container(),
      ],
    );;
  }

}