import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/supplier.dart';
import 'package:medical_chain_manangement/services/supplier_service.dart';
import 'package:provider/provider.dart';

class Partner extends StatefulWidget {
  @override
  _Partner createState() => _Partner();
}

class _Partner extends State<Partner> {
  SupplierService supplierService = SupplierService();
  List<Supplier> suppliers = List.empty();

  bool isCalled = false;

  void getAllSupplier(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      supplierService
          .getAllSupplier(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          suppliers = List.from(result);
          isCalled = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  Map<String, String> dates = {'start_date': '', 'end_date': ''};
  String branch_value = '-1';

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    getAllSupplier(auth);

    return Scaffold(
      appBar: AppBar(
        title: Text("Tất cả các nhà cung cấp"),
        actions: <Widget>[
          if (auth.employee["role"] == "manager")
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: () {
                Navigator.pushNamed(context, '/partner_add');
              },
            )
        ],
      ),
      body: Row(
        children: <Widget>[
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: DataTable(
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(
                          label: Text("Id"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Tên nhà cung cấp"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Số điện thoại"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Email"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Địa chỉ"),
                          numeric: false,
                        ),
                      ],
                      rows: suppliers
                          .map(
                            (supplier) => DataRow(
                              onSelectChanged: (value) {
                                if (auth.employee["role"] == "manager") {
                                  Navigator.pushNamed(
                                      context, '/partner_detail',
                                      arguments: supplier);
                                }
                              },
                              cells: [
                                DataCell(
                                  Text(
                                    supplier.id.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    supplier.name!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    supplier.contact!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    supplier.email!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    supplier.address!,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
