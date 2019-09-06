import 'package:deal/entities/product.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/ui/rate_ui/rate_user_details.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RateSliverListContent extends StatelessWidget {
  final ProductEntity product;
  final double rating;
  final Function(double) onRateChanged;
  final Function onRate;
  final UserEntity user;
  final bool isRating;

  const RateSliverListContent(
      {Key key,
      @required this.product,
      @required this.rating,
      @required this.onRateChanged,
      @required this.user, this.onRate, this.isRating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = Dimens.Width;
    // TODO: implement build
    return SliverList(
      delegate: new SliverChildListDelegate(<Widget>[
        Padding(
            padding: EdgeInsets.only(
              top: width * .3,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Text(
                    product.price,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Values.primaryColor,
                        fontSize: 17.0),
                  ),
                ),
                Text(
                  product.desc,
                  style: TextStyle(
                      color: Colors.grey.withOpacity(.7),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: RateUserDetails(
                    user: user,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: SmoothStarRating(
                    color: Values.ratingColor,
                    allowHalfRating: false,
                    starCount: 5,
                    spacing: (width - (width * .7)) / 5,
                    rating: rating,
                    onRatingChanged: onRateChanged,
                    borderColor: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: MaterialButton(
                    onPressed: onRate,
                    minWidth: width,
                    color: Values.primaryColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: isRating ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),) : Text("Rate"),
                    ),
                    textColor: Colors.white,
                  ),
                )
              ],
            ))
      ]),
    );
  }
}
