import 'package:deal/entities/product.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/ui/rate_ui/rate_sliver_list_content.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/products_webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RateUserScreen extends StatefulWidget {
  final ProductEntity product;
  final UserEntity user;

  const RateUserScreen({Key key, this.product, this.user}) : super(key: key);

  createState() => _UserRatingState();
}

class _UserRatingState extends State<RateUserScreen> {
  final _height = Dimens.Height, _width = Dimens.Width;
  double _rating = .0;
  bool _isRating = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Builder(
          builder: (context) => SliverFab(
                slivers: <Widget>[
                  new SliverAppBar(
                    expandedHeight: _height * .4,
                    pinned: true,
                    floating: false,
                    title: Text("Rate the buyer"),
                    backgroundColor: Values.primaryColor,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                    ),
                  ),
                  RateSliverListContent(
                    rating: _rating,
                    user: widget.user,
                    product: widget.product,
                    onRateChanged: (rate) => setState(() => _rating = rate),
                    onRate: () async {
                      if (!_isRating) {
                        setState(() {
                          _isRating = true;
                        });
                        await ProductWebService().rateBuyer(userId: widget.user.id, productId: widget.product.id, rating: _rating);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    isRating: _isRating,
                  ),
                ],
                floatingWidget: Container(
                  width: _width * .4,
                  height: _width * .4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 3.5,
                      ),
                      color: Values.primaryColor),
                  padding: EdgeInsets.all(3.0),
                  child: ClipRRect(
                    child: TransitionToImage(
                      image: AdvancedNetworkImage(widget.product.thumb,
                          useDiskCache: true),
                      loadingWidget: Image.asset(
                        "assets/icon_no_image.png",
                      ),
                      placeholder: Image.asset(
                        "assets/icon_no_image.png",
                      ),
                      width: _width * .2,
                      height: _width * .2,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                floatingPosition: FloatingPosition(
                    top: -_width * .1,
                    left: (_width / 2) - _width * .2,
                    right: (_width / 2) - _width * .2),
              )),
    );
  }
}
