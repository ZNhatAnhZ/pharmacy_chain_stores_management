import 'dart:convert';
import 'dart:developer';

import 'package:medical_chain_manangement/config.dart';
import 'package:http/http.dart' as http;

import '../models/charts/header_statistic.dart';

class HeaderStatisticService {
  Future<HeaderStatistic> getAllHeaderStatistic(
      String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/statistic/header_statistic';
    } else {
      url = '/api/v1/manager/statistic/header_statistic';
    }
    final response = await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      dynamic parsedListJson = jsonDecode(response.body);
      print(parsedListJson);
      HeaderStatistic result = HeaderStatistic.fromJson(parsedListJson);
      return result;
    } else {
      throw Exception(response.body);
    }
  }
}
