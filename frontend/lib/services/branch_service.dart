import 'dart:convert';
import 'dart:developer';

import 'package:medical_chain_manangement/config.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class BranchService {
  Future<List<Branch>> getAllBranch(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/branches';
    } else if (role == 'manager') {
      url = '/api/v1/manager/branches';
    } else if (role == 'admin') {
      url = '/api/v1/admins/branches';
    } else {
      url = '/api/v1/store_owner/branches';
    }
    final response = await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<Branch> result = List<Branch>.from(
          parsedListJson.map<Branch>((dynamic i) => Branch.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> createBranch(String token, Map data, String role) async {
    if (data.isEmpty) {
      Fluttertoast.showToast(
          msg: "Tạo mới chi nhánh thất bại",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          fontSize: 16.0);
    }
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/branches';
    } else if (role == 'manager') {
      url = '/api/v1/manager/branches';
    } else {
      url = '/api/v1/store_owner/branches';
    }
    final response = await http.post(Uri.http(BASE_URL, url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'name': data['name'],
      'address': data['address'],
      'branch_code': data['branch_code'],
      'email': data['email'],
      'contact': data['contact'],
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Tạo chi nhánh mới thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      Fluttertoast.showToast(
            msg: "Tạo chi nhánh mới thất bại",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0);
      throw Exception(response.toString());
    }
  }

  Future<bool> updateBranch(String token, Map data, String role) async {
    inspect(data);
    var branch_id = data['id'];
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/branches/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/branches/';
    } else {
      url = '/api/v1/store_owner/branches/';
    }
    final response =
        await http.put(Uri.http(BASE_URL, url + branch_id), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'name': data['name'],
      'address': data['address'],
      'branch_code': data['branch_code'],
      'email': data['email'],
      'contact': data['contact'],
    });

    if (response.statusCode == 200) {
      inspect(response);
      Fluttertoast.showToast(
          msg: "Sửa chi nhánh thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.toString());
    }
  }

  Future<bool> deleteBranch(String token, String id, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/branches/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/branches/';
    } else {
      url = '/api/v1/store_owner/branches/';
    }
    final response = await http.delete(Uri.http(BASE_URL, url + id), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Xóa chi nhánh thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.body);
    }
  }
}
