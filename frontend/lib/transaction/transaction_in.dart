import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/models/import_inventory.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:medical_chain_manangement/services/import_inventory.dart';
import 'package:provider/provider.dart';

class TransactionIn extends StatefulWidget {
  @override
  _TransactionIn createState() => _TransactionIn();
}

class _TransactionIn extends State<TransactionIn> {
  ImportInventoryService importInventoryService = ImportInventoryService();
  List<ImportInventory> importInventory = List.empty();
  BranchService branchService = BranchService();
  List<Branch> branches = List.empty();

  bool isCalled = false;
  bool isCalled1 = false;

  void getAllInventory(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      importInventoryService
          .getAllImportInventory(
              auth.employee['access_token'], auth.employee['role'], '', dates)
          .then((result) {
        setState(() {
          importInventory = List.from(result);
          isCalled = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getAllBranch(AuthBlock auth) {
    if (isCalled1 == false &&
        auth.isLoggedIn &&
        auth.employee['role'] == "manager") {
      branchService
          .getAllBranch(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          result.add(Branch(id: -1, name: 'All branches'));
          branches = List.from(result);
          isCalled1 = true;
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
    getAllInventory(auth);
    getAllBranch(auth);

    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        const Padding(
          padding: EdgeInsets.only(
            left: 60,
            top: 15,
            bottom: 10,
          ),
          child: Text(
            "Giao dịch vào",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Expanded(
          child: Center(
            child: ElevatedButton(
              onPressed: () async {
                final values = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.range,
                  ),
                  dialogSize: const Size(325, 400),
                  borderRadius: BorderRadius.circular(15),
                  dialogBackgroundColor: Colors.white,
                );
                if (values != null) {
                  bool flag = true;
                  values.forEach((element) {
                    if (flag) {
                      dates['start_date'] = element.toString().substring(0, 10);
                      flag = false;
                    } else {
                      dates['end_date'] = element.toString().substring(0, 10);
                    }
                  });
                } else {
                  dates['start_date'] = '';
                  dates['end_date'] = '';
                }
                print(values);

                if (auth.isLoggedIn) {
                  importInventoryService
                      .getAllImportInventory(auth.employee['access_token'],
                          auth.employee['role'], branch_value, dates)
                      .then((result) {
                    setState(() {
                      importInventory = List.from(result);
                      isCalled = true;
                    });
                  }).catchError((err) {
                    print(err);
                  });
                }
              },
              child: const Text('Lọc theo khoảng thời gian'),
            ),
          ),
        ),
        if (auth.isLoggedIn && auth.employee['role'] == 'manager')
          Padding(
              padding: EdgeInsets.only(
                right: 60,
                top: 15,
                bottom: 10,
              ),
              child: DropdownButton<int>(
                value: int.parse(branch_value),
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 1,
                  color: Colors.black,
                ),
                onChanged: (int? value) {
                  if (auth.isLoggedIn) {
                    importInventoryService
                        .getAllImportInventory(auth.employee['access_token'],
                            auth.employee['role'], value.toString(), dates)
                        .then((result) {
                      setState(() {
                        importInventory = List.from(result);
                        branch_value = value.toString();
                      });
                    }).catchError((err) {
                      print(err);
                    });
                  }
                },
                items: branches.map<DropdownMenuItem<int>>((Branch value) {
                  return DropdownMenuItem<int>(
                    value: value.id,
                    child: Text(value.name!),
                  );
                }).toList(),
              )),
        IconButton(
          icon: const Icon(Icons.download_sharp),
          onPressed: () {
            importInventoryService.exportImportInventoryCSV(
                auth.employee['access_token'],
                auth.employee['role'],
                branch_value);
          },
        ),
      ]),
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
                          label: Text("ID"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Giá tiền"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Số lượng"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Mã nhập hàng"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Mã thuốc"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Tên nhà cung cấp"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Mã lô"),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text("Ngày hết hạn lô"),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text("Tên nhân viên"),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text("Ngày tạo"),
                          numeric: true,
                        ),
                      ],
                      rows: importInventory
                          .map(
                            (product) => DataRow(
                              onSelectChanged: (value) {
                                Navigator.pushNamed(
                                    context, '/transaction_in_detail',
                                    arguments: product);
                              },
                              cells: [
                                DataCell(
                                  Text(
                                    product.id.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    product.price.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    product.quantity.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    product.import_inventory_code!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    product.inventory!.inventory_code!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    product.supplier!.name!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    product.batch_inventory!.batch_code!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    product.batch_inventory!.expired_date!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    product.employee!.name!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    product.created_date!,
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
