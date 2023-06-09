import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'dart:typed_data';

import 'package:medical_chain_manangement/config.dart';
import 'package:medical_chain_manangement/models/inventory.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';

class InventoryService {
  Future<List<Inventory>> getAllInventory(
      String token, String role, String branch_id) async {
    if (branch_id == '-1') {
      branch_id = '';
    }
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/inventories';
    } else if (role == 'manager') {
      url = '/api/v1/manager/inventories';
    } else if (role == 'customer') {
      url = '/api/v1/customers/inventories';
    } else {
      url = '/api/v1/store_owner/inventories';
    }
    final response = await http
        .get(Uri.http(BASE_URL, url, {'branch_id': branch_id}), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<Inventory> result = List<Inventory>.from(
          parsedListJson.map<Inventory>((dynamic i) => Inventory.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<Inventory>> getSearchedInventory(String token, String role,
      String branch_id, String search_name, List<bool> selectedFilters) async {
    String url;
    String sort_price = '';
    String created_time = '';
    String most_ordered = '';
    if (selectedFilters[0]) {
      sort_price = 'asc';
    }
    if (selectedFilters[1]) {
      sort_price = 'desc';
    }
    if (selectedFilters[2]) {
      most_ordered = 'true';
    }
    if (selectedFilters[3]) {
      created_time = 'desc';
    }
    if (selectedFilters[4]) {
      created_time = 'asc';
    }
    if (branch_id == '-1') {
      branch_id = '';
    }
    if (role == 'employee') {
      url = '/api/v1/employ/inventories';
    } else if (role == 'manager') {
      url = '/api/v1/manager/inventories';
    } else if (role == 'customer') {
      url = '/api/v1/customers/inventories';
    } else {
      url = '/api/v1/store_owner/inventories';
    }
    final response = await http.get(
        Uri.http(BASE_URL, url, {
          'search_name': search_name,
          'branch_id': branch_id,
          'sort_price': sort_price,
          'created_time': created_time,
          'most_ordered': most_ordered,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<Inventory> result = List<Inventory>.from(
          parsedListJson.map<Inventory>((dynamic i) => Inventory.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<Inventory> createInventory(
      String token, Map data, Uint8List image, String role) async {
    if (data.isEmpty || image.isEmpty) {
      Fluttertoast.showToast(
          msg: "Tạo mới sản phẩm thất bại",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
    }
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/inventories';
    } else if (role == 'manager') {
      url = '/api/v1/manager/inventories';
    } else {
      url = '/api/v1/store_owner/inventories';
    }

    var request = http.MultipartRequest('POST', Uri.http(BASE_URL, url));

    request.files.add(http.MultipartFile.fromBytes("image", image,
        filename: data['image_name'], contentType: MediaType('image', 'jpeg')));

    request.headers.addAll({
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer $token',
    });

    if (data["branch_id"] != null) {
      request.fields.addAll({
        "name": data["name"],
        "price": data["price"],
        "quantity": data["quantity"],
        "inventory_type": data["inventory_type"],
        "category_id": data["category_id"],
        "batch_inventory_id": data["batch_inventory_id"],
        "supplier_id": data["supplier_id"],
        "inventory_code": data["inventory_code"],
        "main_ingredient": data["main_ingredient"],
        "branch_id": data["branch_id"],
        "producer": data["producer"]
      });
    } else {
      request.fields.addAll({
        "name": data["name"],
        "price": data["price"],
        "quantity": data["quantity"],
        "inventory_type": data["inventory_type"],
        "category_id": data["category_id"],
        "batch_inventory_id": data["batch_inventory_id"],
        "supplier_id": data["supplier_id"],
        "inventory_code": data["inventory_code"],
        "main_ingredient": data["main_ingredient"],
        "producer": data["producer"]
      });
    }

    inspect(request.toString());

    final response = await request.send();

    inspect(response);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Tạo mới sản phẩm thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return Inventory.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    } else {
      Fluttertoast.showToast(
          msg: "Tạo mới sản phẩm thất bại",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
      throw Exception(response.toString());
    }
  }

  Future<Inventory> updateInventory(
      String token, Map data, Uint8List? image, String role) async {
    if (data.isEmpty) {
      Fluttertoast.showToast(
          msg: "Sửa sản phẩm thất bại",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
    }
    var inventory_id = data['id'];
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/inventories/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/inventories/';
    } else {
      url = '/api/v1/store_owner/inventories/';
    }
    var request =
        http.MultipartRequest('PUT', Uri.http(BASE_URL, url + inventory_id));

    if (image != null) {
      request.files.add(http.MultipartFile.fromBytes("image", image,
          filename: data['image_name'],
          contentType: MediaType('image', 'jpeg')));
    }

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.fields.addAll({
      "name": data["name"],
      "price": data["price"],
      "quantity": data["quantity"],
      "inventory_type": data["inventory_type"],
      "category_id": data["category_id"],
      "batch_inventory_id": data["batch_inventory_id"],
      "supplier_id": data["supplier_id"],
      "inventory_code": data["inventory_code"],
      "main_ingredient": data["main_ingredient"],
      "producer": data["producer"]
    });

    final response = await request.send();

    if (response.statusCode == 200) {
      inspect(response);
      Fluttertoast.showToast(
          msg: "Sửa sản phẩm thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return Inventory.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    } else {
      Fluttertoast.showToast(
          msg: "Sửa sản phẩm thất bại",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
      throw Exception(response.toString());
    }
  }

  Future<bool> deleteInventory(String token, String id, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/inventories/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/inventories/';
    } else {
      url = '/api/v1/store_owner/inventories/';
    }
    final response = await http.delete(Uri.http(BASE_URL, url + id), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Xóa sản phẩm thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Xóa sản phẩm thất bại",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
      throw Exception(response.body);
    }
  }

  void exportInventoryCSV(String token, String role, String branch_id) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/export_csv/export_inventory';
    } else if (role == 'manager') {
      url = '/api/v1/manager/export_csv/export_inventory';
    } else {
      url = '/api/v1/store_owner/export_csv/export_inventory';
    }
    if (branch_id == '-1') {
      branch_id = '';
    }
    final anchor = AnchorElement(
        href: Uri.http(BASE_URL, url, {'branch_id': branch_id}).toString())
      ..click();
  }

  Future<List<Inventory>> getExpiredInventory(
      String token, String role, String branch_id) async {
    if (branch_id == '-1') {
      branch_id = '';
    }
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/inventories/get_expired';
    } else if (role == 'manager') {
      url = '/api/v1/manager/inventories/get_expired';
    } else {
      url = '/api/v1/store_owner/inventories/get_expired';
    }
    final response = await http.get(
        Uri.http(BASE_URL, url, {'day_left': '0', 'branch_id': branch_id}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<Inventory> result = List<Inventory>.from(
          parsedListJson.map<Inventory>((dynamic i) => Inventory.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<Inventory>> getOutOfStockInventory(
      String token, String role, String branch_id) async {
    if (branch_id == '-1') {
      branch_id = '';
    }
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/inventories/get_out_of_stock';
    } else if (role == 'manager') {
      url = '/api/v1/manager/inventories/get_out_of_stock';
    } else {
      url = '/api/v1/store_owner/inventories/get_out_of_stock';
    }
    final response = await http.get(
        Uri.http(BASE_URL, url, {'quantity_left': '0', 'branch_id': branch_id}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<Inventory> result = List<Inventory>.from(
          parsedListJson.map<Inventory>((dynamic i) => Inventory.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> deleteAllExpiredInventory(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/inventories/destroy_all_expired';
    } else if (role == 'manager') {
      url = '/api/v1/manager/inventories/destroy_all_expired';
    } else {
      url = '/api/v1/store_owner/inventories/destroy_all_expired';
    }
    final response = await http.delete(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Xóa tất cả các sản phẩm hết hạn thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> sendMailToSupplier(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/inventories/send_request_mail_to_supplier';
    } else if (role == 'manager') {
      url = '/api/v1/manager/inventories/send_request_mail_to_supplier';
    } else {
      url = '/api/v1/store_owner/inventories/send_request_mail_to_supplier';
    }
    final response = await http
        .get(Uri.http(BASE_URL, url, {'quantity_left': '0'}), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Gửi email đến các nhà cung cấp thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.body);
    }
  }
}
