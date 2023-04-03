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
      url = '/api/v1/branches';
    } else {
      url = '/api/v1/ad/branches';
    }
    final response = await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      print(parsedListJson);
      List<Branch> result = List<Branch>.from(
          parsedListJson.map<Branch>((dynamic i) => Branch.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }
}
