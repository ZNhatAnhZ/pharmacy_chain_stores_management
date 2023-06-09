import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/config.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordService {
  Future<bool> forgotPassword(String email) async {
    final response = await http.post(
        Uri.http(BASE_URL, '/api/v1/password/forgot', {
          'email': email,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == 200) {
      inspect(response);
      Fluttertoast.showToast(
          msg: "Đã gửi mã xác nhận đến email của bạn, vui lòng kiểm tra mã xác thực trong email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Vui lòng nhập đúng email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
      throw Exception(response.toString());
    }
  }

  Future<bool> resetPassword(
      String email, String forgotPasswordToken, String password) async {
    final response = await http.post(
        Uri.http(BASE_URL, '/api/v1/password/reset', {
          'email': email,
          'token': forgotPasswordToken,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == 200) {
      inspect(response);
      Fluttertoast.showToast(
          msg: "Thay đổi mật khẩu thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Thay đổi mật khẩu thất bại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
      throw Exception(response.toString());
    }
  }

  Future<bool> updateAccountInfo(
      Map data, String role, String id, String token) async {
    inspect(data);
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/employees/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/employees/';
    } else if (role == 'customer') {
      url = '/api/v1/customers/customers/me';
    } else {
      url = '/api/v1/store_owner/employees/';
    }
    final response = await http.put(
        Uri.http(BASE_URL, url + (role != 'employee' ? id : '')),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'name': data["name"],
          'current_password': data["old_password"],
          'password': data["new_password"],
          'address': data["address"],
          'contact': data["contact"],
          'gender': data["gender"],
        });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Cập nhật thông tin thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Cập nhật thông tin thất bại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
      inspect(response);
      return false;
    }
  }
}
