import 'dart:io';

import 'package:deal/entities/category.dart';
import 'package:deal/entities/product.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/entities/user.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/web_service/webservice_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProductWebService extends WebserviceConfig {

  Future<List<ProductEntity>> getPosts({double lat, double lng, CategoryEntity category, int offset}) async {
    Map<String, dynamic> params = {
      "latitude": lat ?? AppData.Latitude,
      "longitude": lng ?? AppData.Longitude,
      "radius": 500,
      //"sub_category_id": null,
      //"category_id": null,
      "offset": offset
    };

    if (category != null){
      params['category_id'] = category.id;
      if(category.subCategory != null && category.subCategory.isNotEmpty)
        params['sub_category_id'] = category.subCategory[0].id;
    }

    try {
      final url = AppData.User != null
          ? WebserviceConfig.PRODUCTS
          : WebserviceConfig.PRODUCTS_GUEST;
      final response = await dio.get(url,
          queryParameters: params);
      List<dynamic> data = response.data['data']['records'];
      List<ProductEntity> products = List();
      for (final prod in data) products.add(ProductEntity(data: prod));
      return products;
    } catch (e) {
      return null;
    }
  }

  Future<ProductDetailsEntity> getProductDetails(int id) async {
    //try{
    final url = "${WebserviceConfig.PRODUCT_DETAILS}$id/${AppData.User != null ? "" : "guest"}";
    final response = await dio.get(
        url);
    return ProductDetailsEntity.fromJson(response.data['data']);
    /*}catch(e){
      print(e);
      return null;
    }*/
  }

  Future<bool> postProduct(ProductDetailsEntity product) async{

    FormData formData = FormData.from({
      'title': product.title,
      "address": product.location,
      "description": product.desc,
      "price": product.price,
      "symbol": "\$",
      "category_id": product.cat.id,
      "country_id": product.country,
      "city_id": product.city,
      "state": product.state,
      "latitude": product.lat,
      "longitude": product.lng
    });

    if (product.subCategory != null)
      formData.add("sub_category_id", product.subCat.id);

    for (int i = 0; i < product.images.length; i++)
      formData.add("files[$i]", UploadFileInfo(File(product.images[i].img), "${DateTime.now().millisecond}.jpg"));

    print("files 0: ${formData['files[0]']}");

    try {
      await dio.post(WebserviceConfig.CREATE_POST, data: formData);
      return true;
    }catch(e){
      print((e as DioError).message);
      return false;
    }
  }


  Future<Function> saveProduct(int id) async {
    try {
      await dio.post("${WebserviceConfig.SAVE_PRODUCT}/$id");
    }catch(err){
    }
  }

  Future<Function> reportProduct(int productId, String reason) async {
    Map<String, dynamic> params = {
      "reason" : reason,
      "user_id": AppData.User.id,
      "post_id" : productId
    };
    await dio.post(WebserviceConfig.REPORT, data: params,);
  }


  Future deleteProduct(int id) async {
    await dio.post("${WebserviceConfig.DELETE_PRODUCT}$id");
    return;
  }

  Future<List<UserEntity>> getBuyersList(int productId) async {

    final response = await dio.get("${WebserviceConfig.BUYERS_LIST}$productId");

    List<UserEntity> users = List();

    for (final data in response.data['data'])
      users.add(UserEntity.fromJson(data));

    return users;
  }

  Future<bool> rateBuyer({@required int userId,@required int productId,@required rating}) async {
    Map<String, dynamic> params = {
      "user_id": userId,
      "ratting": rating,
    };
    try {
      await dio.post("${WebserviceConfig.RATE}$productId", data: params);
      return true;
    }catch(e){
      if(e is DioError)
      return false;
    }
  }
}
