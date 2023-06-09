import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/config.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../models/customer.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<Map> employeeLogin(EmployeeCredential employeeCredential) async {
    final response =
        await http.post(Uri.http(BASE_URL, '/api/v1/login'), headers: {
      "Access-Control-Allow-Origin": "*",
    }, body: {
      'email': employeeCredential.email,
      'password': employeeCredential.password
    });
    inspect(response.body);
    if (response.statusCode == 200) {
      setEmployee(response.body);
      Fluttertoast.showToast(
          msg: "Đăng nhập thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Tên tài khoản hoặc mật khẩu không đúng",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
            fontSize: 16.0);
      }
      throw Exception(response.body);
    }
  }

  Future<Map> employeeRegister(Employee employee) async {
    final response = await http.post(Uri.http(BASE_URL, '/api/v1/employees'),
        body: {
          'name': employee.name,
          'password': employee.password,
          'email': employee.email
        });
    inspect(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: 'Email đã tồn tại',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
            fontSize: 16.0);
      }
      throw Exception(response.body);
    }
  }

  Future<Map> customerLogin(EmployeeCredential employeeCredential) async {
    final response = await http
        .post(Uri.http(BASE_URL, '/api/v1/customers/login'), headers: {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    }, body: {
      'email': employeeCredential.email,
      'password': employeeCredential.password
    });
    inspect(response.body);
    if (response.statusCode == 200) {
      setEmployee(response.body);
      Fluttertoast.showToast(
          msg: "Đăng nhập thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Tên tài khoản hoặc mật khẩu không đúng",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
            fontSize: 16.0);
      }
      throw Exception(response.body);
    }
  }

  Future<Map> customerRegister(Customer customer) async {
    final response = await http
        .post(Uri.http(BASE_URL, '/api/v1/customers/customers'), body: {
      'name': customer.name,
      'password': customer.password,
      'email': customer.email,
    });
    inspect(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Đăng ký thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return jsonDecode(response.body);
    } else {
      Fluttertoast.showToast(
          msg: 'Đăng ký thất bại',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
      throw Exception(response.body);
    }
  }

  Future<Map> adminLogin(EmployeeCredential employeeCredential) async {
    final response =
        await http.post(Uri.http(BASE_URL, '/api/v1/admins/login'), headers: {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    }, body: {
      'email': employeeCredential.email,
      'password': employeeCredential.password
    });
    inspect(response.body);
    if (response.statusCode == 200) {
      setEmployee(response.body);
      Fluttertoast.showToast(
          msg: "Đăng nhập thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Tên tài khoản hoặc mật khẩu không đúng",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
            fontSize: 16.0);
      }
      throw Exception(response.body);
    }
  }

  setEmployee(String value) async {
    await storage.write(key: 'employee', value: value);
  }

  getEmployee() async {
    String? employee = await storage.read(key: 'employee');
    if (employee != null) {
      return jsonDecode(employee);
    }
    return {};
  }

  logout() async {
    await storage.delete(key: 'employee');
  }
}
