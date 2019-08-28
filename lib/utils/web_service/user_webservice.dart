import 'dart:io';

import 'package:deal/entities/product.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/utils/web_service/webservice_config.dart';
import 'package:dio/dio.dart';

import '../appdata.dart';

class UserWebService extends WebserviceConfig {

    Future<UserEntity> login(String mail, String passwd) async {
      //final dio = dio;
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

    Future<Map<String, dynamic>> getProductHistory() async {
      try{
        final url = "${WebserviceConfig.PRODUCTS_HISTORY}/${AppData.User.id}";
        final response = await dio.get(url);

        Map<String, dynamic> result = Map();

        result['count'] = response.data['data']['count'];

        List<ProductEntity> products = List();
        for (final data in response.data['data']['records'])
          products.add(ProductEntity(data: data));

        result['products'] = products;

        return result;

      }catch(e){
        return null;
      }
    }
}