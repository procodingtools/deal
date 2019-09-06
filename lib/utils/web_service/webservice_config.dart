import 'package:dio/dio.dart';

import '../appdata.dart';

class WebserviceConfig {
  static final _BASE_URL = "http://api.deal4ya.com/api/v1/",
      CATEGORIES = _BASE_URL + "category",
      PRODUCTS = _BASE_URL + "post/list",
      PRODUCTS_GUEST = PRODUCTS + "/guest",
      PRODUCT_DETAILS = _BASE_URL + "post/details/",
      CREATE_POST = _BASE_URL + "post/create",
      LOGIN = _BASE_URL + "login",
      REGISTER = _BASE_URL + "register",
      CHAT_LIST = _BASE_URL + "chat/list",
      CHAT_ROOM = _BASE_URL + "chat/message/history/",
      SEND_MESSAGE = _BASE_URL + "openfire/send-notification",
      PRODUCTS_HISTORY = _BASE_URL + "post/user",
      SAVE_PRODUCT = _BASE_URL + "post/save",
      GET_SAVED_PRODUCTS = _BASE_URL + "post/save/list",
      UPDATE_PROFILE = _BASE_URL + "user/update/",
      UPDATE_PASSWD = _BASE_URL + "user/change-password/",
      RESET_PASSWD = _BASE_URL + "forgot-password",
      FB_LOGIN = "social-login",
      GET_NOTIFICATIONS = _BASE_URL + "user/notification",
      DELETE_PRODUCT = _BASE_URL + "post/delete/",
      UPDATE_PRODUCT = _BASE_URL + "post/update/",
      BUYERS_LIST = _BASE_URL + "post/chat/user/",
      RATE = _BASE_URL + "post/sold/",
      REPORT = _BASE_URL + "post/report";

  final dio = Dio()..options = BaseOptions(headers: AppData.Headers);
}
