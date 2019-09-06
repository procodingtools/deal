import 'package:deal/entities/notification.dart';
import 'package:deal/utils/web_service/webservice_config.dart';

class NotificationsWebSerrvice extends WebserviceConfig{

  Future<List<NotificationEntity>> getNotifs() async {
    //try{
      List<NotificationEntity> notifs = List();
      final response = await dio.get(WebserviceConfig.GET_NOTIFICATIONS);
      for(final notif in response.data['data'])
        notifs.add(NotificationEntity.fromJson(notif));
      return notifs;
    /*}catch(e){
      print(e.response);
      return null;
    }*/
  }

}