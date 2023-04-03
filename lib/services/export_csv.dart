import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:medical_chain_manangement/config.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ExportCSVService {
  void exportCSV(String token) async {
    final anchor =
        AnchorElement(href: '$BASE_URL/api/v1/export_csv/export_inventory')
          ..click();
  }
}
