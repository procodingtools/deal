import 'package:date_format/date_format.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/utils/dimens.dart';
import 'package:flutter/material.dart';

class ProfileSliverList extends StatelessWidget{

  final UserEntity user;
  final int soldCount;

  final Widget optionTabs;

  const ProfileSliverList({Key key, this.user, this.soldCount, this.optionTabs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliverList(
      delegate: new SliverChildListDelegate(<Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: Dimens.Width * .42,
                  ),
                  Text(
                    "Joined on ${formatDate(user.joinDate, [
                      M,
                      ' ',
                      yyyy
                    ])}",
                    style: TextStyle(
                        color: Colors.grey.withOpacity(.8),
                        fontSize: 10.0),
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 8.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${soldCount ?? "0"} Items sold",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                              fontFamily: "Gilroy"),
                        ),
                      )),
                ],
              ),
              optionTabs,
            ],
          ),
        )
      ]),
    );
  }
  
}