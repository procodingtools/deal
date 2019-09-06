import 'package:date_format/date_format.dart';
import 'package:deal/entities/notification.dart';
import 'package:deal/utils/dimens.dart';
import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class NotifItem extends StatelessWidget {
  final NotificationEntity notif;

  const NotifItem({Key key, this.notif}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration dur = DateTime.now().difference(notif.sent);
    String duration = dur.inDays >= 7
        ? formatDate(notif.createdAt, [dd, "-", M, "-", yyyy])
        : dur.inDays >= 1
            ? "${dur.inDays} d ago"
            : dur.inHours >= 1
                ? "${dur.inHours} h ago"
                : dur.inMinutes >= 1
                    ? "${dur.inMinutes} m ago"
                    : "${dur.inSeconds} s ago";
    // TODO: implement build
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _profilePic(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    notif.message,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              Text(
                duration,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Divider(
          height: 1.0,
        )
      ],
    );
  }

  Widget _profilePic() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Values.primaryColor, width: 3.0),
          shape: BoxShape.circle),
      padding: EdgeInsets.all(5.0),
      child: TransitionToImage(
        image: AdvancedNetworkImage(notif.fromUser.profilePicThumb),
        placeholder: ClipRRect(
          child: Image.asset(
            'assets/icon_profile_default.png',
            width: 50.0,
          ),
          borderRadius: BorderRadius.circular(500.0),
        ),
        loadingWidget: ClipRRect(
          child: Image.asset(
            'assets/icon_profile_default.png',
            width: 50.0,
          ),
          borderRadius: BorderRadius.circular(500.0),
        ),
        borderRadius: BorderRadius.circular(500.0),
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      ),
    );
  }
}
