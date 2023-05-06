import 'dart:convert';
import 'dart:developer';

import 'package:medical_chain_manangement/config.dart';
import 'package:medical_chain_manangement/models/customer.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class CustomerService {
  Future<List<Customer>> getAllCustomer(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/customers';
    } else if (role == 'manager') {
      url = '/api/v1/manager/customers';
    } else if (role == 'admin') {
      url = '/api/v1/admins/customers';
    } else {
      url = '/api/v1/store_owner/customers';
    }
    final response = await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<Customer> result = List<Customer>.from(
          parsedListJson.map<Customer>((dynamic i) => Customer.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> updateCustomer(String token, Map data, String role) async {
    var customer_id = data['id'];
    String url;
    if (role == 'customer') {
      url = '/api/v1/employ/customers/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/customers/';
    } else {
      url = '/api/v1/store_owner/customers/';
    }
    final response = await http.put(
        Uri.http(BASE_URL, url + customer_id, {
          'name': data['name'],
          'email': data['email'],
          'address': data['address'],
          'contact': data['contact'],
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      inspect(response);
      Fluttertoast.showToast(
          msg: "Sửa thông tin khách hàng thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.toString());
    }
  }

  Future<bool> deleteCustomer(String token, String id, String role) async {
    String url;
    if (role == 'customer') {
      url = '/api/v1/employ/customers/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/customers/';
    } else {
      url = '/api/v1/store_owner/customers/';
    }
    final response = await http.delete(Uri.http(BASE_URL, url + id), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Xóa khách hàng thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> createCustomer(String token, Map data, String role) async {
    String url;
    if (role == 'customer') {
      url = '/api/v1/employ/customers';
    } else if (role == 'manager') {
      url = '/api/v1/manager/customers';
    } else {
      url = '/api/v1/store_owner/customers';
    }

    final response = await http.post(Uri.http(BASE_URL, url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'name': data['name'],
      'email': data['email'],
      'address': data['address'],
      'contact': data['contact'],
      'password': data['password'],
      'password_confirmation': data['password'],
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Tạo tài khoản khách hàng thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.toString());
    }
  }
}
