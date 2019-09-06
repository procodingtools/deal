import 'package:deal/entities/product.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/utils/web_service/webservice_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import '../appdata.dart';

class UserWebService extends WebserviceConfig {
  Future<UserEntity> login(String mail, String passwd) async {
    //final dio = dio;
    Map<String, dynamic> params = {
      "email": mail,
      "password": passwd,
      "device_token": AppData.FCM,
    };

    try {
      final response = await dio.post(WebserviceConfig.LOGIN,
          data: params);

      return UserEntity(data: response.data['data']);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getProductHistory(int id) async {
    try {
      final url = "${WebserviceConfig.PRODUCTS_HISTORY}/$id";
      final response = await dio.get(url);

      Map<String, dynamic> result = Map();

      result['count'] = response.data['data']['count'];

      List<ProductEntity> products = List();
      for (final data in response.data['data']['records'])
        products.add(ProductEntity(data: data));

      result['products'] = products;


      return result;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getFavProducts() async {
    final response = await dio.get(WebserviceConfig.GET_SAVED_PRODUCTS);

    List<ProductEntity> favs = List();

    Map<String, dynamic> result = Map();

    result['count'] = response.data['data']['count'];

    for (final data in response.data['data']['records'])
      favs.add(ProductEntity(data: data));

    result['products'] = favs;

    return result;
  }

  Future updateUser(String name) async {
    Map<String, dynamic> params = {
      "full_name": name,
      "mobile_no": "0",
    };

    await dio
        .post(WebserviceConfig.UPDATE_PROFILE, data: params)
        .catchError((err) {
    });

    return;
  }

  Future<bool> updatePasswd(String old, String newer) async {
    Map<String, dynamic> data = {
      "current_password": old,
      "password": newer,
      "password_confirmation": newer,
    };

    try {
      await dio.post(WebserviceConfig.UPDATE_PASSWD, data: data);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> resetPasswd(String email) async {
     Map<String, dynamic> data = {"email": email};

     try{
       await dio.put(WebserviceConfig.RESET_PASSWD, data: data);
       return true;
     }catch(e){
       return false;
     }
  }

  Future<UserEntity> signinFacebook(FirebaseUser user, FacebookAccessToken token) async {
    Map<String, dynamic> data = {
      "fb_id": token.userId,
      "email": user.email,
      "device_token": AppData.FCM,
      "full_name": user.displayName,
    };
    try {
      final response = await dio.post(WebserviceConfig.FB_LOGIN, data: data);
      return UserEntity(data: response.data['data']);
    }catch(e){
      return null;
    }
  }


  Future<bool> rateUser({@required int userId,@required int productId,@required double rate}) async {
    Map<String, dynamic> params = {
      "user_id": userId,
      "ratting": rate,
    };
    try {
      await dio.post("${WebserviceConfig.RATE}$productId", data: params);
      return true;
    }catch(e){
      return false;
    }
  }
}
