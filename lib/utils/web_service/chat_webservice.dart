import 'dart:convert';

import 'package:deal/entities/chat_entity.dart';
import 'package:deal/entities/chat_message.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/web_service/webservice_config.dart';
import 'package:dio/dio.dart';

class ChatWebService extends WebserviceConfig {
  Future<List<ChatEntity>> getChatList() async {
    try {
      final result = await dio.get(WebserviceConfig.CHAT_LIST);

      List<dynamic> list = result.data['data'];
      List<ChatEntity> chats = List();

      for (final entity in list) {
        chats.add(ChatEntity.fromJson(entity));
      }

      return chats;
    } catch (e) {
      return null;
    }
  }

  Future<List<ChatMessageEntity>> getChatRoom(int userId, int productId) async {
    try {
      Map<String, dynamic> params = {
        "user_id": userId,
        "post_id": productId,
        "offset": 0
      };

      final response =
          await dio.get(WebserviceConfig.CHAT_ROOM, queryParameters: params);

      List<ChatMessageEntity> messages = List();

      for (final msg in response.data['data']['records'])
        messages.add(ChatMessageEntity.fromJson(msg));

      return messages;
    } catch (e) {
      return null;
    }
  }

  Future<VoidCallback> sendMsg(int userId, int productId, {String text}) async {
    Map<String, String> data = {
      'fromValue': AppData.User.id.toString() + AppData.XMPP_DOMAIN_ID_APPEND,
      "toValue": userId.toString() + AppData.XMPP_DOMAIN_ID_APPEND,
      "post_id": productId.toString(),
    };

    if (text != null) {
      data['chatType'] = "chat";
      data['message'] = text;
    }

    await dio.post(WebserviceConfig.SEND_MESSAGE, data: data);
  }
}
