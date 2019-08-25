import 'package:deal/entities/product.dart';
import 'package:deal/entities/product_details.dart';
import 'package:deal/utils/appdata.dart';
import 'package:deal/utils/web_service/webservice_config.dart';
import 'package:dio/dio.dart';

class ProductWebService {
  Future<List<ProductEntity>> getPosts() async {
    final dio = Dio();
    Map<String, String> headers = Map.from(AppData.Headers);

    try {
      final url = AppData.User != null
          ? WebserviceConfig.PRODUCTS
          : WebserviceConfig.PRODUCTS_GUEST;
      print(url);
      final response = await dio.get(url,
          queryParameters: {
            "latitude": 36.9269028,
            "longitude": 128.31706,
            "radius": 500,
            //"sub_category_id": null,
            //"category_id": null,
            "offset": 0
          },
          options: Options(headers: headers));
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
    final dio = Dio();
    //try{
    final url = "${WebserviceConfig.PRODUCT_DETAILS}$id/${AppData.User != null ? "" : "guest"}";
    print(url);
    final response = await dio.get(
        url,
        options: Options(headers: AppData.Headers));
    return ProductDetailsEntity.fromJson(response.data['data']);
    /*}catch(e){
      print(e);
      return null;
    }*/
  }
}
