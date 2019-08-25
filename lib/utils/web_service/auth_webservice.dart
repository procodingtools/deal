import 'dart:io';

import 'package:deal/entities/user.dart';
import 'package:deal/utils/web_service/webservice_config.dart';
import 'package:dio/dio.dart';

import '../appdata.dart';

class AuthWebService {

    Future<UserEntity> login(String mail, String passwd) async {
      final dio = Dio();
      Map<String, dynamic> params = {
        "email": mail,
        "password": passwd,
        //"device_token": "lkjhjghcgfjklguhkln,",
      },
      headers = Map.from(AppData.Headers);


      try {
        final response = await dio.post(WebserviceConfig.LOGIN, data: params,
            options: Options(headers: headers));

        return UserEntity(data: response.data['data']);
      }catch(e){
        return null;
      }

    }
}