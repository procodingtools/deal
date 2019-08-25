import 'dart:io';

import 'package:deal/entities/category.dart';
import 'package:deal/entities/user.dart';

class AppData{
  static List<CategoryEntity> Categories;
  static String Toekn;
  static String Latitude = "", Longitude = "";
  static UserEntity User;
  static Map<String, String> Headers = {
    "Accept": "application/json",
    "os-type": Platform.operatingSystem.toUpperCase()
  };
}