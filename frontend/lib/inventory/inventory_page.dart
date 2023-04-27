import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/models/inventory.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:medical_chain_manangement/services/inventory_service.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPage createState() => _InventoryPage();
}

class _InventoryPage extends State<InventoryPage> {
  InventoryService inventoryService = InventoryService();
  BranchService branchService = BranchService();
  List<Inventory> inventorys = List.empty();
  List<Branch> branches = List.empty();

  bool isCalled = false;
  bool isCalled1 = false;

  void getAllInventory(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      inventoryService
          .getAllInventory(
              auth.employee['access_token'], auth.employee['role'], '')
          .then((result) {
        setState(() {
          inventorys = List.from(result);
          isCalled = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getAllBranch(AuthBlock auth) {
    if (isCalled1 == false && auth.isLoggedIn) {
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

  void getSearchedInventory(AuthBlock auth) {
    if (auth.isLoggedIn) {
      inventoryService
          .getSearchedInventory(
              auth.employee['access_token'],
              auth.employee['role'],
              branch_value,
              search_name_value,
              selectedFilters)
          .then((result) {
        setState(() {
          inventorys = List.from(result);
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getExpiredInventory(AuthBlock auth) {
    if (auth.isLoggedIn) {
      inventoryService
          .getExpiredInventory(
        auth.employee['access_token'],
        auth.employee['role'],
        branch_value,
      )
          .then((result) {
        setState(() {
          inventorys = List.from(result);
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getOutOfStockInventory(AuthBlock auth) {
    if (auth.isLoggedIn) {
      inventoryService
          .getOutOfStockInventory(
        auth.employee['access_token'],
        auth.employee['role'],
        branch_value,
      )
          .then((result) {
        setState(() {
          inventorys = List.from(result);
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  String search_name_value = '';
  String branch_value = '-1';
  final List<bool> selectedFilters = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    AuthBlock auth = Provider.of<AuthBlock>(context);
    getAllInventory(auth);
    getAllBranch(auth);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              left: 60,
              top: 15,
              bottom: 10,
            ),
            child: Text(
              "Drug inventory",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 600,
                child: Material(
                  shadowColor: Colors.grey.shade200,
                  type: MaterialType.transparency,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      hintText: "Search products",
                      hintStyle: TextStyle(color: Colors.white24),
                    ),
                    onChanged: (value) {
                      search_name_value = value;
                      getSearchedInventory(auth);
                    },
                  ),
                ),
              ),
            ),
          ),
          if (auth.isLoggedIn && auth.employee['role'] == 'admin')
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
                      inventoryService
                          .getSearchedInventory(
                              auth.employee['access_token'],
                              auth.employee['role'],
                              value.toString(),
                              search_name_value,
                              selectedFilters)
                          .then((result) {
                        setState(() {
                          inventorys = List.from(result);
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
              inventoryService.exportInventoryCSV(auth.employee['access_token'],
                  auth.employee['role'], branch_value);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/add_inventory_page');
            },
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              ToggleButtons(
                direction: Axis.vertical,
                onPressed: (int index) {
                  // All buttons are selectable.
                  setState(() {
                    selectedFilters[index] = !selectedFilters[index];
                    for (int i = 0; i < selectedFilters.length; i++) {
                      if (i != index) {
                        selectedFilters[i] = false;
                      }
                    }
                    if (index == 5 && selectedFilters[index]) {
                      getExpiredInventory(auth);
                    } else if (index == 6 && selectedFilters[index]) {
                      getOutOfStockInventory(auth);
                    } else {
                      getSearchedInventory(auth);
                    }
                  });
                },
                renderBorder: false,
                selectedBorderColor: Colors.blue[700],
                selectedColor: Colors.white,
                fillColor: Colors.blue[200],
                color: Colors.blue[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: selectedFilters,
                children: <Widget>[
                  Container(
                    width: 160,
                    padding: EdgeInsets.all(8.0),
                    child: Text('Lọc giá tăng dần'),
                  ),
                  Container(
                    width: 160,
                    padding: EdgeInsets.all(8.0),
                    child: Text('Lọc giá giảm dần'),
                  ),
                  Container(
                    width: 160,
                    padding: EdgeInsets.all(8.0),
                    child: Text('Lọc ordered giảm dần'),
                  ),
                  Container(
                    width: 160,
                    padding: EdgeInsets.all(8.0),
                    child: Text('Lọc ngày tạo gần nhất'),
                  ),
                  Container(
                    width: 160,
                    padding: EdgeInsets.all(8.0),
                    child: Text('Lọc ngày tạo xa nhất'),
                  ),
                  Container(
                    width: 160,
                    padding: EdgeInsets.all(8.0),
                    child: Text('Lọc đã hết hạn'),
                  ),
                  Container(
                    width: 160,
                    padding: EdgeInsets.all(8.0),
                    child: Text('Lọc đã hết hàng'),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text('Xóa sản phẩm hết hạn',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  inventoryService
                      .deleteAllExpiredInventory(
                          auth.employee['access_token'], auth.employee['role'])
                      .then((value) => Navigator.pushReplacementNamed(
                          context, '/inventory_page'))
                      .catchError((err) => print(err));
                },
              ),
              SizedBox(
                height: 10,
              ),
              if (auth.isLoggedIn && auth.employee['role'] == 'admin')
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                      "Gửi sản phẩm hết hạn" + '\n' + " cho bên cung cấp",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    inventoryService
                        .sendMailToSupplier(auth.employee['access_token'],
                            auth.employee['role'])
                        .catchError((err) => print(err));
                  },
                )
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 190,
                      child: Scrollbar(
                        controller: scrollController,
                        child: SingleChildScrollView(
                          controller: scrollController,
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
                                  label: Text("Mã thuốc"),
                                  numeric: false,
                                ),
                                DataColumn(
                                  label: Text("Tên thuốc"),
                                  numeric: false,
                                ),
                                DataColumn(
                                  label: Text("Giá"),
                                  numeric: false,
                                ),
                                DataColumn(
                                  label: Text("Batch code"),
                                  numeric: false,
                                ),
                                DataColumn(
                                  label: Text("Tên nhà sản xuất"),
                                  numeric: false,
                                ),
                                DataColumn(
                                  label: Text("Loại thuốc"),
                                  numeric: false,
                                ),
                                DataColumn(
                                  label: Text("Số lần được đặt"),
                                  numeric: false,
                                ),
                                DataColumn(
                                  label: Text("Ngày tạo"),
                                  numeric: false,
                                ),
                              ],
                              rows: inventorys
                                  .map(
                                    (inventory) => DataRow(
                                      onSelectChanged: (value) {
                                        Navigator.pushNamed(
                                            context, '/inventory_detail',
                                            arguments: inventory);
                                      },
                                      cells: [
                                        DataCell(
                                          Text(
                                            inventory.id!.toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            inventory.inventory_code!,
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
                                            inventory
                                                .batch_inventory!.batch_code!,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            inventory.producer!,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            inventory.inventory_type!,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            inventory.total_order_quantity
                                                .toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            inventory.created_date!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
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
