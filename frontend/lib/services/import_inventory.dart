import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:medical_chain_manangement/config.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_chain_manangement/models/import_inventory.dart';

class ImportInventoryService {
  Future<List<ImportInventory>> getAllImportInventory(String token, String role,
      String branch_id, Map<String, String> dates) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/import_inventories';
    } else {
      url = '/api/v1/manager/import_inventories';
    }
    if (branch_id == '-1') {
      branch_id = '';
    }
    final response = await http.get(
        Uri.http(BASE_URL, url, {
          'branch_id': branch_id,
          'start_date': dates['start_date'],
          'end_date': dates['end_date'],
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      print(parsedListJson);
      List<ImportInventory> result = List<ImportInventory>.from(parsedListJson
          .map<ImportInventory>((dynamic i) => ImportInventory.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<ImportInventory> createImportInventory(String token, Map data) async {
    final response = await http
        .post(Uri.http(BASE_URL, '/api/v1/import_inventories'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      "price": data["price"],
      "quantity": data["quantity"],
      "inventory_id": data["inventory_id"],
      "batch_inventory_id": data["batch_inventory_id"],
      "supplier_id": data["supplier_id"]
    });

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      Fluttertoast.showToast(
          msg: "Created a new import inventory",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return ImportInventory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  void exportImportInventoryCSV(
      String token, String role, String branch_id) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/export_csv/export_import_inventory';
    } else {
      url = '/api/v1/manager/export_csv/export_import_inventory';
    }
    if (branch_id == '-1') {
      branch_id = '';
    }
    final anchor = AnchorElement(
        href: Uri.http(BASE_URL, url, {'branch_id': branch_id}).toString())
      ..click();
  }
}
