import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class FloattingProfilePicture extends StatelessWidget{
  final String picUrl;
  final bool editProfile;

  const FloattingProfilePicture({Key key,@required this.picUrl,@required this.editProfile}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final width = Dimens.Width;

    // TODO: implement build
    return Container(
      width: width * .3,
      height: width * .3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.white,
            width: 3.5,
          ),
          color: Values.primaryColor),
      padding: EdgeInsets.all(3.0),
      child: ClipRRect(
        child: Stack(
          children: <Widget>[
            TransitionToImage(
              image: AdvancedNetworkImage(picUrl,
                  useDiskCache: true),
              loadingWidget: Image.asset(
                "assets/icon_profile_default.png",
              ),
              placeholder: Image.asset(
                "assets/icon_profile_default.png",
              ),
            ),
            editProfile
                ? Align(
              alignment: Alignment.topRight,
              child: Material(
                color: Colors.black26,
                child: InkWell(
                  splashColor: Colors.white30,
                  onTap: () => print('import img'),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(Icons.photo_camera),
                  ),
                ),
              ),
            )
                : Container()
          ],
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

}