import 'dart:convert';
import 'dart:developer';

import 'package:medical_chain_manangement/config.dart';
import 'package:medical_chain_manangement/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class CategoryService {
  Future<List<Category>> getAllCategory(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/categories';
    } else {
      url = '/api/v1/manager/categories';
    }
    final response = await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      print(parsedListJson);
      List<Category> result = List<Category>.from(
          parsedListJson.map<Category>((dynamic i) => Category.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }
}
