import 'package:deal/entities/category.dart';
import 'package:deal/utils/web_service/webservice_config.dart';
import 'package:dio/dio.dart';

class CategoriesWebService extends WebserviceConfig{
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final response = await dio.get(WebserviceConfig.CATEGORIES);
      List<dynamic> data = response.data['data'];
      List<CategoryEntity> categories = List();
      for (final cat in data) categories.add(CategoryEntity(data: cat));
      return categories;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
