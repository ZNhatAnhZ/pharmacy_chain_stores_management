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
      url = '/api/v1/employ/batch_inventories';
    } else if (role == 'manager') {
      url = '/api/v1/manager/batch_inventories';
    } else {
      url = '/api/v1/store_owner/batch_inventories';
    }
    final response = await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<BatchInventory> result = List<BatchInventory>.from(parsedListJson
          .map<BatchInventory>((dynamic i) => BatchInventory.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<BatchInventory> createBatchInventory(
      String token, String batch_code, String expired_date, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/batch_inventories';
    } else if (role == 'manager') {
      url = '/api/v1/manager/batch_inventories';
    } else {
      url = '/api/v1/store_owner/batch_inventories';
    }
    final response = await http.post(Uri.http(BASE_URL, url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'batch_code': batch_code,
      'expired_date': expired_date
    });

    if (response.statusCode == 200) {
      inspect(jsonDecode(response.body));
      Fluttertoast.showToast(
          msg: "Tạo lô mới thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return BatchInventory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
