import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/employee/add_employee.dart';
import 'package:medical_chain_manangement/employee/employee_detail.dart';
import 'package:medical_chain_manangement/employee/employee_modify.dart';
import 'package:medical_chain_manangement/employee/employee_page.dart';
import 'package:medical_chain_manangement/home/home_page.dart';
import 'package:medical_chain_manangement/auth/employee_auth.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/inventory/add_inventory_page.dart';
import 'package:medical_chain_manangement/inventory/inventory_detail.dart';
import 'package:medical_chain_manangement/inventory/inventory_detail_modify.dart';
import 'package:medical_chain_manangement/inventory/inventory_page.dart';
import 'package:medical_chain_manangement/import_inventory/import_inventory_detail.dart';
import 'package:medical_chain_manangement/ledger/ledger_page.dart';
import 'package:medical_chain_manangement/partner/partner_detail.dart';
import 'package:medical_chain_manangement/selling_drug/selling_drug.dart';
import 'package:medical_chain_manangement/store/store.dart';
import 'package:medical_chain_manangement/transaction/transaction_in.dart';
import 'package:medical_chain_manangement/partner/partner.dart';
import 'package:medical_chain_manangement/transaction/transaction_in_detail.dart';
import 'package:medical_chain_manangement/transaction/transaction_out_detail.dart';
import 'package:medical_chain_manangement/user_settings/settings.dart';
import 'package:provider/provider.dart';

import 'transaction/transaction_out.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider<AuthBlock>.value(value: AuthBlock())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/auth',
      routes: {
        '/': (context) => HomePage(),
        '/auth': (context) => EmployeeAuth(),
        '/inventory_page': (context) => InventoryPage(),
        '/add_inventory_page': (context) => AddInventoryPage(),
        '/inventory_detail': (context) => InventoryDetail(),
        '/inventory_detail_modify': (context) => InventoryDetailModify(),
        '/import_inventory_detail': (context) => ImportInventoryDetail(),
        '/selling_drug': (context) => SellingDrug(),
        '/transaction_in': (context) => TransactionIn(),
        '/transaction_in_detail': (context) => TransactionInDetail(),
        '/transaction_out': (context) => TransactionOut(),
        '/transaction_out_detail': (context) => TransactionOutDetail(),
        '/partner': (context) => Partner(),
        '/partner_detail': (context) => PartnerDetail(),
        '/store': (context) => Store(),
        '/ledger': (context) => LedgerPage(),
        '/settings': (context) => Settings(),
        '/employee_page': (context) => EmployeePage(),
        '/employee_detail': (context) => EmployeeDetail(),
        '/employee_modify': (context) => EmployeeModify(),
        '/employee_add': (context) => AddEmployee(),
      },
    );
  }
}
