import 'dart:io';

import 'package:deal/entities/category.dart';
import 'package:deal/entities/product.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/web_service/webservice_config.dart';
import 'package:dio/dio.dart';

class ProductWebService extends WebserviceConfig {
  Future<List<ProductEntity>> getPosts({double lat, double lng, CategoryEntity category, int offset}) async {
    Map<String, dynamic> params = {
      "latitude": lat ?? 36.9269028,
      "longitude": lng ?? 128.31706,
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
      print(url);
      final response = await dio.get(url,
          queryParameters: params);
      List<dynamic> data = response.data['data']['records'];
      List<ProductEntity> products = List();
      for (final prod in data) products.add(ProductEntity(data: prod));
      return products;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ProductDetailsEntity> getProductDetails(int id) async {
    //try{
    final url = "${WebserviceConfig.PRODUCT_DETAILS}$id/${AppData.User != null ? "" : "guest"}";
    print(url);
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
      "sub_category_id": product.subCat.id,
      "country_id": product.country,
      "city_id": product.city,
      "state": product.state,
      "latitude": product.lat,
      "longitude": product.lng
    });

    for (int i = 0; i < product.images.length; i++)
      formData.add("files[$i]", UploadFileInfo(File(product.images[i].img), "${DateTime.now().millisecond}.jpg"));

    try {
      await dio.post(WebserviceConfig.CREATE_POST, data: formData).catchError((error){
        print(error.response);
      });
      return true;
    }catch(e){
      return false;
    }
  }


  Future<Function> saveProduct(int id) async {
    await dio.post("${WebserviceConfig.SAVE_PRODUCT}/$id");
  }

  Future<Function> reportProduct(int productId, String reason) async {
    Map<String, dynamic> params = {
      "reason" : reason,
      "user_id": AppData.User.id,
      "post_id" : productId
    };
    await dio.post(WebserviceConfig.REPORT, data: params,);
  }
}
