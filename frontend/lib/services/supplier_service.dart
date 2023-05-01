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
      url = '/api/v1/employ/suppliers';
    } else if (role == 'manager') {
      url = '/api/v1/manager/suppliers';
    } else {
      url = '/api/v1/store_owner/suppliers';
    }
    final response = await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<Supplier> result = List<Supplier>.from(
          parsedListJson.map<Supplier>((dynamic i) => Supplier.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<Inventory>> getAllInventoriesOfSupplier(
      String token, String role, int supplier_id) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/suppliers/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/suppliers/';
    } else {
      url = '/api/v1/store_owner/suppliers/';
    }
    final response = await http
        .get(Uri.http(BASE_URL, url + supplier_id.toString()), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<Inventory> result = List<Inventory>.from(parsedListJson['inventory']
          .map<Inventory>((dynamic i) => Inventory.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> createSupplier(String token, Map data, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/suppliers';
    } else if (role == 'manager') {
      url = '/api/v1/manager/suppliers';
    } else {
      url = '/api/v1/store_owner/suppliers';
    }
    final response = await http.post(Uri.http(BASE_URL, url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'name': data['name'],
      'contact': data['contact'],
      'email': data['email'],
      'address': data['address']
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Created a new supplier",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.toString());
    }
  }

  Future<bool> updateSupplier(String token, Map data, String role) async {
    inspect(data);
    var supplier_id = data['id'];
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/suppliers/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/suppliers/';
    } else {
      url = '/api/v1/store_owner/suppliers/';
    }
    final response =
        await http.put(Uri.http(BASE_URL, url + supplier_id), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'name': data['name'],
      'contact': data['contact'],
      'email': data['email'],
      'address': data['address']
    });

    if (response.statusCode == 200) {
      inspect(response);
      Fluttertoast.showToast(
          msg: "Updated the supplier",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.toString());
    }
  }

  Future<bool> deleteSupplier(String token, String id, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/suppliers/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/suppliers/';
    } else {
      url = '/api/v1/store_owner/suppliers/';
    }
    final response = await http.delete(Uri.http(BASE_URL, url + id), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Deleted the supplier",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.body);
    }
  }
}
