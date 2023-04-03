import 'dart:convert';
import 'dart:developer';

import 'package:medical_chain_manangement/config.dart';
import 'package:medical_chain_manangement/models/batch_inventory.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_chain_manangement/models/inventory.dart';
import 'package:medical_chain_manangement/models/supplier.dart';

class SupplierService {
  Future<List<Supplier>> getAllSupplier(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/suppliers';
    } else {
      url = '/api/v1/ad/suppliers';
    }
    final response = await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      print(parsedListJson);
      List<Supplier> result = List<Supplier>.from(
          parsedListJson.map<Supplier>((dynamic i) => Supplier.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

    Future<List<Inventory>> getAllInventoriesOfSupplier(String token, String role, int supplier_id) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/suppliers/';
    } else {
      url = '/api/v1/ad/suppliers/';
    }
    final response = await http.get(Uri.http(BASE_URL, url+supplier_id.toString()), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> parsedListJson = jsonDecode(response.body);
      print(parsedListJson);
      List<Inventory> result = List<Inventory>.from(
          parsedListJson['inventory'].map<Inventory>((dynamic i) => Inventory.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }
}
