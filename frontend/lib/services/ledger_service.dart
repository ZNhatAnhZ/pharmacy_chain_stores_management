import 'dart:convert';
import 'dart:html';

import 'package:medical_chain_manangement/config.dart';
import 'package:medical_chain_manangement/models/ledger.dart';
import 'package:http/http.dart' as http;

class LedgerService {
  Future<List<Ledger>> getAllLedger(String token, String role, String branch_id,
      Map<String, String> dates) async {
    if (branch_id == '-1') {
      branch_id = '';
    }
    String url;
    if (role == 'employee') {
      url = '/api/v1/ledger';
    } else {
      url = '/api/v1/manager/ledger';
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
      List<Ledger> result = List<Ledger>.from(
          parsedListJson.map<Ledger>((dynamic i) => Ledger.fromJson(i)));
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  void exportLedgerCSV(String token, String role, String branch_id) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/export_csv/export_ledger';
    } else {
      url = '/api/v1/manager/export_csv/export_ledger';
    }
    if (branch_id == '-1') {
      branch_id = '';
    }
    final anchor = AnchorElement(
        href: Uri.http(BASE_URL, url, {'branch_id': branch_id}).toString())
      ..click();
  }
}
