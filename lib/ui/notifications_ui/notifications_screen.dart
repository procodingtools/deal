import 'package:deal/entities/notification.dart';
import 'package:deal/ui/notifications_ui/notif_item.dart';
import 'package:deal/utils/values.dart';
import 'package:deal/utils/web_service/notificatios_webservice.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsScreen> {
  List<NotificationEntity> _notifications = List();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationsWebSerrvice().getNotifs().then((notifs) {
      setState(() {
        _isLoading = false;
        if (notifs != null) _notifications.addAll(notifs);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Values.primaryColor,
        title: Text('Notifications'),
      ),
      body: Container(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  final notif = _notifications[index];
                  return NotifItem(notif: notif,);
                },
                itemCount: _notifications.length,
              ),
      ),
    );
  }
}
