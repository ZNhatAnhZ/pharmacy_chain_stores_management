import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:medical_chain_manangement/config.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class EmployeeService {
  Future<List<Employee>> getAllEmployee(
      String token, String role, String branch_id) async {
    if (branch_id == '-1') {
      branch_id = '';
    }
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/employees';
    } else if (role == 'manager') {
      url = '/api/v1/manager/employees';
    } else if (role == 'admin') {
      url = '/api/v1/admins/employees';
    } else {
      url = '/api/v1/store_owner/employees';
    }
    final response = await http.get(
        Uri.http(BASE_URL, url, {
          'branch_id': branch_id,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<Employee> result = List<Employee>.from(
          parsedListJson.map<Employee>((dynamic i) => Employee.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  void exportEmployeeCSV(String token, String role, String branch_id) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/export_csv/export_employee';
    } else if (role == 'manager') {
      url = '/api/v1/manager/export_csv/export_employee';
    } else {
      url = '/api/v1/store_owner/export_csv/export_employee';
    }
    if (branch_id == '-1') {
      branch_id = '';
    }
    final anchor = AnchorElement(
        href: Uri.http(BASE_URL, url, {'branch_id': branch_id}).toString())
      ..click();
  }

  Future<bool> updateEmployee(String token, Map data, String role) async {
    inspect(data);
    var employee_id = data['id'];
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/employees/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/employees/';
    } else if (role == 'admin') {
      url = '/api/v1/admins/employees/';
    } else {
      url = '/api/v1/store_owner/employees/';
    }
    final response = await http.put(
        Uri.http(BASE_URL, url + employee_id, {
          'name': data['name'],
          'email': data['email'],
          'branch_id': data['branch_id'],
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      inspect(response);
      Fluttertoast.showToast(
          msg: "Cập nhật employee thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.toString());
    }
  }

  Future<bool> deleteEmployee(String token, String id, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/employees/';
    } else if (role == 'manager') {
      url = '/api/v1/manager/employees/';
    } else if (role == 'admin') {
      url = '/api/v1/admins/employees/';
    } else {
      url = '/api/v1/store_owner/employees/';
    }
    final response = await http.delete(Uri.http(BASE_URL, url + id), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Xóa employee thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> createEmployee(String token, Map data, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/employees';
    } else if (role == 'manager') {
      url = '/api/v1/manager/employees';
    } else if (role == 'admin') {
      url = '/api/v1/admins/employees';
    } else {
      url = '/api/v1/store_owner/employees';
    }

    final response;
    if (data['branch_id'] != null) {
      if (data['role'] != null) {
        response = await http.post(Uri.http(BASE_URL, url), headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }, body: {
          'name': data['name'],
          'email': data['email'],
          'contact': data['contact'],
          'gender': data['gender'],
          'address': data['address'],
          'password': data['password'],
          'password_confirmation': data['password'],
          'branch_id': data['branch_id'],
          'role': data['role'],
        });
      } else {
        response = await http.post(Uri.http(BASE_URL, url), headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }, body: {
          'name': data['name'],
          'email': data['email'],
          'contact': data['contact'],
          'gender': data['gender'],
          'address': data['address'],
          'password': data['password'],
          'password_confirmation': data['password'],
          'branch_id': data['branch_id'],
        });
      }
    } else {
      if (data['role'] != null) {
        response = await http.post(Uri.http(BASE_URL, url), headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }, body: {
          'name': data['name'],
          'email': data['email'],
          'contact': data['contact'],
          'gender': data['gender'],
          'address': data['address'],
          'password': data['password'],
          'password_confirmation': data['password'],
          'role': data['role'],
        });
      } else {
        response = await http.post(Uri.http(BASE_URL, url), headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }, body: {
          'name': data['name'],
          'email': data['email'],
          'contact': data['contact'],
          'gender': data['gender'],
          'address': data['address'],
          'password': data['password'],
          'password_confirmation': data['password'],
        });
      }
    }

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Tạo employee thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.toString());
    }
  }
}
