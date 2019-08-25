import 'package:deal/entities/user.dart';
import 'package:deal/ui/common/shimmer_text.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';


class DetailsProfileCard extends StatelessWidget{

  final bool isLoading;
  final UserEntity user;

  const DetailsProfileCard({Key key, this.isLoading, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Map<String, String> headers = Map.from(AppData.Headers);

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0))),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 50.0,
                    top: 30.0,
                    bottom: 30.0,
                    right: 10.0),
                child: Row(
                  children: <Widget>[
                    !isLoading ? Text(
                      user.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ) : ShimmerText(width: 50.0, height: 15.0,),
                    Expanded(child: Container()),
                    Icon(
                      Icons.star,
                      color: Values.ratingColor,
                    ),
                    Text(
                      " ${user?.rating??.0}",
                      style:
                      TextStyle(color: Values.ratingColor),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.share,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Values.primaryColor, width: .5), shape: BoxShape.circle),
              padding: EdgeInsets.all(2.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xffD2D7DB)),
                  child: TransitionToImage(
                    loadingWidget : Image.asset("assets/icon_profile_default.png", width: 70.0, ),
                    placeholder: Image.asset("assets/icon_profile_default.png", width: 70.0, ),
                    image: AdvancedNetworkImage(user?.thumb??"null", useDiskCache: true, cacheRule: CacheRule(maxAge: Duration(days: 10)), header: headers),
                    width: 70.0,
                    borderRadius: BorderRadius.circular(double.infinity),
                    height: 70.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}