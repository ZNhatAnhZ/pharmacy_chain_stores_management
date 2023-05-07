import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/batch_inventory.dart';
import 'package:medical_chain_manangement/models/inventory.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medical_chain_manangement/models/supplier.dart';
import 'package:medical_chain_manangement/services/batch_service.dart';
import 'package:medical_chain_manangement/services/import_inventory.dart';
import 'package:medical_chain_manangement/services/inventory_service.dart';
import 'package:medical_chain_manangement/services/supplier_service.dart';
import 'package:provider/provider.dart';

import '../home/drawer.dart';

class ImportInventoryDetail extends StatefulWidget {
  @override
  _ImportInventoryDetailState createState() => _ImportInventoryDetailState();
}

class _ImportInventoryDetailState extends State<ImportInventoryDetail> {
  InventoryService inventoryService = InventoryService();
  BatchInventoryService batchInventoryService = BatchInventoryService();
  SupplierService supplierService = SupplierService();
  ImportInventoryService importInventoryService = ImportInventoryService();
  TextEditingController batch_date = TextEditingController();

  List<Inventory> inventorys = List.empty();
  List<BatchInventory> batchInventory = List.empty();
  List<Supplier> supplier = List.empty();

  bool isCalled = false;
  bool isCalled1 = false;
  bool isCalled2 = false;

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

  void getAllBatchInventory(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      batchInventoryService
          .getAllBatchInventory(
              auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          batchInventory = List.from(result);
          isCalled1 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getAllSupplier(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      supplierService
          .getAllSupplier(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          supplier = List.from(result);
          isCalled2 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  Map newImportInventory = {};
  Map newBatchInventory = {};

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    getAllInventory(auth);
    getAllBatchInventory(auth);
    getAllSupplier(auth);

    return Scaffold(
      drawer: Drawer(
        child: AppDrawer(),
      ),
      appBar: AppBar(
        title: const Text("Nhập thêm thuốc"),
      ),
      body: Center(
        child: Form(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSelectedItems: true,
                              showSearchBox: true,
                            ),
                            items: List<String>.of(inventorys
                                .map((e) => e.id!.toString() + ": " + e.name!)),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Chọn thuốc trong kho",
                                hintText: "Chọn thuốc trong kho",
                              ),
                            ),
                            onChanged: (e) {
                              newImportInventory['inventory_id'] =
                                  e?.split(':').elementAt(0);
                              print(e);
                            },
                            // selectedItem: "Brazil",
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: () {
                            Navigator.pushNamed(context, '/add_inventory_page');
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập giá thuốc';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newImportInventory['price'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập giá thuốc',
                        labelText: 'Nhập giá thuốc',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập số lượng thuốc';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newImportInventory['quantity'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập số lượng thuốc',
                        labelText: 'Nhập số lượng thuốc',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        showSearchBox: true,
                      ),
                      items: List<String>.of(supplier
                          .map((e) => e.id!.toString() + ": " + e.name!)),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Chọn nhà sản xuất",
                          hintText: "country in menu mode",
                        ),
                      ),
                      onChanged: (e) {
                        newImportInventory['supplier_id'] =
                            e?.split(':').elementAt(0);
                        print(e);
                      },
                      // selectedItem: "Brazil",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSelectedItems: true,
                              showSearchBox: true,
                              disabledItemFn: (String s) => s.startsWith('I'),
                            ),
                            items: List<String>.of(batchInventory.map((e) =>
                                e.id!.toString() + ": " + e.batch_code!)),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Chọn lô",
                                hintText: "country in menu mode",
                              ),
                            ),
                            onChanged: (e) {
                              newImportInventory['batch_inventory_id'] =
                                  e?.split(':').elementAt(0);
                              print(e);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 12.0,
                                            left: 12.0,
                                            right: 12.0),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Hãy nhập tên lô';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              newBatchInventory["batch_code"] =
                                                  value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Hãy nhập mã lô',
                                            labelText: 'Hãy nhập mã lô',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 12.0,
                                            left: 12.0,
                                            right: 12.0),
                                        child: TextFormField(
                                          controller: batch_date,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Hãy nhập ngày hết hạn';
                                            }
                                            return null;
                                          },
                                          onTap: () async {
                                            final values =
                                                await showCalendarDatePicker2Dialog(
                                              context: context,
                                              config:
                                                  CalendarDatePicker2WithActionButtonsConfig(
                                                calendarType:
                                                    CalendarDatePicker2Type
                                                        .single,
                                              ),
                                              dialogSize: const Size(325, 400),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              dialogBackgroundColor:
                                                  Colors.white,
                                            );

                                            print(values);
                                            if (values != null) {
                                              batch_date.text = values
                                                  .toString()
                                                  .substring(1, 11);
                                              newBatchInventory[
                                                      "expired_date"] =
                                                  batch_date.text;
                                            }
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              newBatchInventory[
                                                  "expired_date"] = value;
                                              print(value);
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Hãy nhập ngày hết hạn',
                                            labelText: 'Hãy nhập ngày hết hạn',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 25.0),
                                        child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              child: Text('Tạo lô mới',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                batchInventoryService
                                                    .createBatchInventory(
                                                        auth.employee[
                                                            'access_token'],
                                                        newBatchInventory[
                                                            'batch_code'],
                                                        newBatchInventory[
                                                            'expired_date'],
                                                        auth.employee['role'])
                                                    .then((result) {
                                                  setState(() {
                                                    batchInventory.add(result);
                                                    Navigator.pop(context);
                                                  });
                                                }).catchError((err) {
                                                  print(err);
                                                });
                                              },
                                            )),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                          ),
                          child: Text('Tạo đơn nhập mới',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            importInventoryService
                                .createImportInventory(
                                    auth.employee['access_token'],
                                    newImportInventory,
                                    auth.employee['role'])
                                .then((value) {
                              Navigator.pushReplacementNamed(
                                  context, '/transaction_in');
                            }).catchError((err) => print(err));
                          },
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
