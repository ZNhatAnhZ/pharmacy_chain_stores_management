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
      url = '/api/v1/employees';
    } else {
      url = '/api/v1/manager/employees';
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
      print(parsedListJson);
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
      url = '/api/v1/export_csv/export_inventory';
    } else {
      url = '/api/v1/manager/export_csv/export_inventory';
    }
    if (branch_id == '-1') {
      branch_id = '';
    }
    final anchor = AnchorElement(
        href: Uri.http(BASE_URL, url, {'branch_id': branch_id}).toString())
      ..click();
  }

  Future<bool> updateEmployee(String token, Map data, String role) async {
    var employee_id = data['id'];
    String url;
    if (role == 'employee') {
      url = '/api/v1/employees/';
    } else {
      url = '/api/v1/manager/employees/';
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
      print(response);
      Fluttertoast.showToast(
          msg: "Updated the employee",
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
      url = '/api/v1/employees/';
    } else {
      url = '/api/v1/manager/employees/';
    }
    final response = await http.delete(Uri.http(BASE_URL, url + id), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Deleted the employee",
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
      url = '/api/v1/employees';
    } else {
      url = '/api/v1/manager/employees';
    }
    final response = await http.post(Uri.http(BASE_URL, url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'name': data['name'],
      'email': data['email'],
      'password': data['password'],
      'password_confirmation': data['password'],
      'branch_id': data['branch_id'],
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Created the employee",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return true;
    } else {
      throw Exception(response.toString());
    }
  }
}
