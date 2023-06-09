import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/inventory.dart';
import 'package:medical_chain_manangement/models/supplier.dart';
import 'package:medical_chain_manangement/services/supplier_service.dart';
import 'package:provider/provider.dart';

class PartnerDetail extends StatefulWidget {
  @override
  _PartnerDetail createState() => _PartnerDetail();
}

class _PartnerDetail extends State<PartnerDetail> {
  SupplierService supplierService = SupplierService();
  List<Inventory> inventories = List.empty();

  bool isCalled = false;

  void getAllInventoriesOfSupplier(AuthBlock auth, Supplier supplier) {
    if (isCalled == false && auth.isLoggedIn) {
      supplierService
          .getAllInventoriesOfSupplier(auth.employee['access_token'],
              auth.employee['role'], supplier.id!)
          .then((result) {
        setState(() {
          inventories = List.from(result);
          isCalled = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    final Supplier supplier =
        ModalRoute.of(context)!.settings.arguments as Supplier;
    getAllInventoriesOfSupplier(auth, supplier);

    return Scaffold(
      appBar: AppBar(
        title: Text("Tất cả sản phẩm của nhà cung cấp"),
      ),
      body: Row(
        children: <Widget>[
          if (auth.isLoggedIn && auth.employee['role'] == 'manager')
            SizedBox(
              width: 10,
            ),
          if (auth.isLoggedIn && auth.employee['role'] == 'manager')
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text('Sửa nhà cung cấp',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/partner_modify',
                        arguments: supplier);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text("Xóa nhà cung cấp",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    supplierService
                        .deleteSupplier(auth.employee['access_token'],
                            supplier.id.toString(), auth.employee['role'])
                        .then((value) =>
                            Navigator.pushReplacementNamed(context, '/partner'))
                        .catchError((err) => print(err));
                  },
                )
              ],
            ),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 190,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width - 190),
                          child: DataTable(
                            border: TableBorder(
                                left: BorderSide(color: Colors.black)),
                            showCheckboxColumn: false,
                            columns: [
                              DataColumn(
                                label: Text("Id"),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text("Tên sản phẩm"),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text("Giá sản phẩm"),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text("Loại sản phẩm"),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text("Số lượng"),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text("Mã sản phẩm"),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text("Thành phần chính"),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text("Nơi sản xuất"),
                                numeric: false,
                              ),
                            ],
                            rows: inventories
                                .map(
                                  (inventory) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          inventory.id.toString(),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          inventory.name!,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          inventory.price.toString(),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          inventory.inventory_type!,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          inventory.quantity.toString(),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          inventory.inventory_code!,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          inventory.main_ingredient!,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          inventory.producer!,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
