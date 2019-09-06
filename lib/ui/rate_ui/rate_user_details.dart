import 'package:deal/entities/user.dart';
import 'package:deal/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class RateUserDetails extends StatelessWidget{

  final UserEntity user;

  const RateUserDetails({Key key,@required this.user}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final width = Dimens.Width;
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            child: TransitionToImage(
              image: AdvancedNetworkImage(user.profilePicThumb,
                  useDiskCache: true),
              loadingWidget: CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/icon_profile_default.png",
                ),
                radius: width * .17,
              ),
              placeholder: CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/icon_profile_default.png",
                ),
                radius: width * .17,
              ),
              width: width * .2,
              height: width * .2,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(500.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Text(
              user.name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );;
  }

}