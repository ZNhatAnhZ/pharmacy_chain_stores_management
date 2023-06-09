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
      url = '/api/v1/employ/orders';
    } else if (role == 'manager') {
      url = '/api/v1/manager/orders';
    } else if (role == 'customer') {
      url = '/api/v1/customers/orders';
    } else {
      url = '/api/v1/store_owner/orders';
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
      inspect(parsedListJson);
      List<Order> result = List<Order>.from(
          parsedListJson.map<Order>((dynamic i) => Order.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<Order> createOrder(String token, Map data, String role) async {
    inspect(data);
    if (data.isEmpty) {
      Fluttertoast.showToast(
          msg: "Tạo mới đơn mua thất bại",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
    }

    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/orders';
    } else if (role == 'manager') {
      url = '/api/v1/manager/orders';
    } else if (role == 'customer') {
      url = '/api/v1/customers/orders';
    } else {
      url = '/api/v1/store_owner/orders';
    }
    final response = await http.post(Uri.http(BASE_URL, url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      "total_price": data["total_price"],
      "total_quantity": data["total_quantity"],
      "inventory_id": data["inventory_id"],
      "customer_id": data["customer_id"],
    });

    if (response.statusCode == 200) {
      inspect(jsonDecode(response.body));
      Fluttertoast.showToast(
          msg: "Tạo mới đơn mua thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return Order.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(
          msg: "Tạo mới đơn mua thất bại",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
      throw Exception(response.body);
    }
  }

  void exportOrderCSV(String token, String role, String branch_id) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/export_csv/export_order';
    } else if (role == 'manager') {
      url = '/api/v1/manager/export_csv/export_order';
    } else {
      url = '/api/v1/store_owner/export_csv/export_order';
    }
    if (branch_id == '-1') {
      branch_id = '';
    }
    final anchor = AnchorElement(
        href: Uri.http(BASE_URL, url, {'branch_id': branch_id}).toString())
      ..click();
  }

  Future<bool> completeOrder(String token, String order_id, String role) async {
    inspect(order_id);
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/orders/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/orders/';
    } else {
      url = '/api/v1/store_owner/orders/';
    }
    final response = await http
        .put(Uri.http(BASE_URL, url + order_id + "/complete_order"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      inspect(jsonDecode(response.body));
      Fluttertoast.showToast(
          msg: "Xác nhận đơn hàng thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Xác nhận đơn hàng thất bại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      throw Exception(response.body);
    }
  }

  Future<bool> rejectOrder(String token, String order_id, String role) async {
    inspect(order_id);
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/orders/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/orders/';
    } else {
      url = '/api/v1/store_owner/orders/';
    }
    final response = await http
        .put(Uri.http(BASE_URL, url + order_id + "/rejected_order"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      inspect(jsonDecode(response.body));
      Fluttertoast.showToast(
          msg: "Từ chối đơn hàng thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      inspect(jsonDecode(response.body));
      Fluttertoast.showToast(
          msg: "Từ chối đơn hàng thất bại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      throw Exception(response.body);
    }
  }

    Future<bool> customerRejectOrder(String token, String order_id, String role) async {
    inspect(order_id);
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/orders/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/orders/';
    } else if (role == 'customer') {
      url = '/api/v1/customers/orders/';
    } else {
      url = '/api/v1/store_owner/orders/';
    }
    final response = await http
        .put(Uri.http(BASE_URL, url + order_id), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      "status": "canceled"
    });

    if (response.statusCode == 200) {
      inspect(jsonDecode(response.body));
      Fluttertoast.showToast(
          msg: "Hủy đơn hàng thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.body);
    }
  }
}
