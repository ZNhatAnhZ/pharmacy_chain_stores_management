import 'dart:convert';

import 'package:medical_chain_manangement/config.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<Map> employeeLogin(EmployeeCredential employeeCredential) async {
    final response =
        await http.post(Uri.http(BASE_URL, '/api/v1/login'), headers: {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    }, body: {
      'email': employeeCredential.email,
      'password': employeeCredential.password
    });
    print(response.body);
    if (response.statusCode == 200) {
      setEmployee(response.body);
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "Invalid Credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
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
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: 'Email already exist',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
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
