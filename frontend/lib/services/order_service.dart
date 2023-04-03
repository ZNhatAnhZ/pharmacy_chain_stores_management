import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:medical_chain_manangement/config.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_chain_manangement/models/order.dart';

class OrderService {
  Future<List<Order>> getAllOrder(String token, String role, String branch_id,
      Map<String, String> dates) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/orders';
    } else {
      url = '/api/v1/ad/orders';
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
      List<Order> result = List<Order>.from(
          parsedListJson.map<Order>((dynamic i) => Order.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<Order> createOrder(String token, Map data) async {
    inspect(data);
    final response =
        await http.post(Uri.parse('$BASE_URL/api/v1/orders'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      "total_price": data["total_price"],
      "total_quantity": data["total_quantity"],
      "inventory_id": data["inventory_id"],
      "customer_name": data["customer_name"],
    });

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      Fluttertoast.showToast(
          msg: "Created a new order",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  void exportOrderCSV(String token, String role, String branch_id) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/export_csv/export_order';
    } else {
      url = '/api/v1/ad/export_csv/export_order';
    }
    if (branch_id == '-1') {
      branch_id = '';
    }
    final anchor = AnchorElement(
        href: Uri.http(BASE_URL, url, {'branch_id': branch_id}).toString())
      ..click();
  }
}
