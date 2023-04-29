import 'dart:convert';
import 'dart:developer';

import 'package:medical_chain_manangement/config.dart';
import 'package:medical_chain_manangement/models/batch_inventory.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class BatchInventoryService {
  Future<List<BatchInventory>> getAllBatchInventory(
      String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/batch_inventories';
    } else {
      url = '/api/v1/manager/batch_inventories';
    }
    final response = await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      print(parsedListJson);
      List<BatchInventory> result = List<BatchInventory>.from(parsedListJson
          .map<BatchInventory>((dynamic i) => BatchInventory.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<BatchInventory> createBatchInventory(
      String token, String batch_code, String expired_date) async {
    final response = await http
        .post(Uri.http(BASE_URL, '/api/v1/batch_inventories'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'batch_code': batch_code,
      'expired_date': expired_date
    });

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      Fluttertoast.showToast(
          msg: "Created a new batch",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return BatchInventory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
