import 'package:deal/entities/user.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';

class SliverBar extends StatelessWidget{

  final UserEntity user;
  final bool editProfile;
  final Function() onEditClicked;

  const SliverBar({Key key, this.user, this.editProfile, this.onEditClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final width = Dimens.Width;
    final height = Dimens.Height;

    // TODO: implement build
    return SliverAppBar(
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: user.id == AppData.User.id && !editProfile
              ? InkWell(
            onTap: () {
              onEditClicked();
            },
            child: Icon(
              Icons.create,
              color: Colors.white,
              size: 30.0,
            ),
          )
              : Container(),
        )
      ],
      expandedHeight: height * .35,
      pinned: true,
      title: Text("${user.name}"),
      floating: false,
      backgroundColor: Values.primaryColor,
      //title: Text("Sliver Fab"),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.only(left: 150.0, bottom: 15.0),
        background: Container(
          width: width,
          child: Text(
            "SliverFab Example",
            style: TextStyle(fontSize: 17.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

}