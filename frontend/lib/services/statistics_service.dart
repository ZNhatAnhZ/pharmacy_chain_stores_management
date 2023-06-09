import 'dart:convert';
import 'dart:developer';

import 'package:medical_chain_manangement/config.dart';
import 'package:http/http.dart' as http;
import 'package:medical_chain_manangement/models/charts/bar_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../models/charts/bar_chart_customer.dart';
import '../models/charts/pie_model.dart';

class StatisticsService {
  Future<List<BarModel>> getRevenueOrder(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/statistic/get_revenue_order';
    } else if (role == 'manager') {
      url = '/api/v1/manager/statistic/get_revenue_order';
    } else {
      url = '/api/v1/store_owner/statistic/get_revenue_order';
    }

    final response =
        await http.get(Uri.http(BASE_URL, url, {'type': 'month'}), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<BarModel> result = parsedListJson.entries
          .map((entry) => BarModel(entry.key, entry.value))
          .toList();
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<BarModel>> getRevenueImport(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/statistic/get_revenue_import_inventory';
    } else if (role == 'manager') {
      url = '/api/v1/manager/statistic/get_revenue_import_inventory';
    } else {
      url = '/api/v1/store_owner/statistic/get_revenue_import_inventory';
    }

    final response =
        await http.get(Uri.http(BASE_URL, url, {'type': 'month'}), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<BarModel> result = parsedListJson.entries
          .map((entry) => BarModel(entry.key, entry.value))
          .toList();
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<BarModel>> getCountOrder(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/statistic/get_order_count';
    } else if (role == 'manager') {
      url = '/api/v1/manager/statistic/get_order_count';
    } else {
      url = '/api/v1/store_owner/statistic/get_order_count';
    }

    final response =
        await http.get(Uri.http(BASE_URL, url, {'type': 'month'}), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<BarModel> result = parsedListJson.entries
          .map((entry) => BarModel(entry.key, entry.value))
          .toList();
      return result;
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<BarModel>> getCountImport(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/statistic/get_import_inventory_count';
    } else if (role == 'manager') {
      url = '/api/v1/manager/statistic/get_import_inventory_count';
    } else {
      url = '/api/v1/store_owner/statistic/get_import_inventory_count';
    }

    final response =
        await http.get(Uri.http(BASE_URL, url, {'type': 'month'}), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<BarModel> result = parsedListJson.entries
          .map((entry) => BarModel(entry.key, entry.value))
          .toList();
      return result;
    } else {
      throw Exception(response.body);
    }
  }

    Future<List<PieModel>> getCountStatus(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/statistic/get_order_by_status';
    } else if (role == 'manager') {
      url = '/api/v1/manager/statistic/get_order_by_status';
    } else {
      url = '/api/v1/store_owner/statistic/get_order_by_status';
    }

    final response =
        await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<PieModel> result = parsedListJson.entries
          .map((entry) => PieModel(entry.key, entry.value))
          .toList();
      return result;
    } else {
      throw Exception(response.body);
    }
  }

      Future<List<BarChartCustomer>> getTopCustomers(String token, String role) async {
    String url;
    if (role == 'employee') {
      url = '/api/v1/employ/statistic/get_top_user_order';
    } else if (role == 'manager') {
      url = '/api/v1/manager/statistic/get_top_user_order';
    } else {
      url = '/api/v1/store_owner/statistic/get_top_user_order';
    }

    final response =
        await http.get(Uri.http(BASE_URL, url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedListJson = jsonDecode(response.body);
      inspect(parsedListJson);
      List<BarChartCustomer> result = parsedListJson.entries
          .map((entry) => BarChartCustomer(entry.key, entry.value))
          .toList();
      return result;
    } else {
      throw Exception(response.body);
    }
  }
}
