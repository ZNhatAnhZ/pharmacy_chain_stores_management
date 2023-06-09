import 'dart:typed_data';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/batch_inventory.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/models/category.dart';
import 'package:medical_chain_manangement/models/inventory.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medical_chain_manangement/models/supplier.dart';
import 'package:medical_chain_manangement/services/batch_service.dart';
import 'package:medical_chain_manangement/services/category_service.dart';
import 'package:medical_chain_manangement/services/import_inventory.dart';
import 'package:medical_chain_manangement/services/inventory_service.dart';
import 'package:medical_chain_manangement/services/supplier_service.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../services/branch_service.dart';

class AddInventoryPage extends StatefulWidget {
  @override
  _AddInventoryPageState createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  var txt = TextEditingController();
  InventoryService inventoryService = InventoryService();
  BatchInventoryService batchInventoryService = BatchInventoryService();
  SupplierService supplierService = SupplierService();
  ImportInventoryService importInventoryService = ImportInventoryService();
  CategoryService categoryService = CategoryService();
  BranchService branchService = BranchService();
  TextEditingController batch_date = TextEditingController();

  List<Inventory> inventorys = List.empty();
  List<BatchInventory> batchInventory = List.empty();
  List<Supplier> supplier = List.empty();
  List<Category> categories = List.empty();
  List<Branch> branches = List.empty();

  bool isCalled = false;
  bool isCalled1 = false;
  bool isCalled2 = false;
  bool isCalled3 = false;
  bool isCalled4 = false;

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
    if (isCalled1 == false && auth.isLoggedIn) {
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
    if (isCalled2 == false && auth.isLoggedIn) {
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

  void getAllCategory(AuthBlock auth) {
    if (isCalled3 == false && auth.isLoggedIn) {
      categoryService
          .getAllCategory(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          categories = List.from(result);
          isCalled3 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getAllBranch(AuthBlock auth) {
    if (isCalled4 == false &&
        auth.isLoggedIn &&
        auth.employee['role'] == "manager") {
      branchService
          .getAllBranch(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          branches = List.from(result);
          isCalled4 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  Map newInventory = {};
  Map newBatchInventory = {};
  Uint8List image_file = Uint8List.fromList(List.empty());

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    getAllInventory(auth);
    getAllBatchInventory(auth);
    getAllSupplier(auth);
    getAllCategory(auth);
    if (auth.employee['role'] == 'manager') {
      getAllBranch(auth);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm thuốc mới vào kho"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập tên thuốc';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newInventory['name'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập tên thuốc',
                        labelText: 'Nhập tên thuốc',
                      ),
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
                          newInventory['price'] = value;
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
                          newInventory['quantity'] = value;
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
                      items: [
                        "0: pill",
                        "1: blister_packs",
                        "2: pill_pack",
                        "3: pill_bottle",
                      ],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Chọn đơn vị thuốc",
                          hintText: "Chọn đơn vị thuốc",
                        ),
                      ),
                      onChanged: (e) {
                        newInventory['inventory_type'] =
                            e?.split(':').elementAt(1).trim();
                        print(e);
                      },
                      // selectedItem: "Brazil",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        showSearchBox: true,
                      ),
                      items: List<String>.of(categories
                          .map((e) => e.id!.toString() + ": " + e.name!)),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Chọn thể loại",
                          hintText: "Chọn thể loại",
                        ),
                      ),
                      onChanged: (e) {
                        newInventory['category_id'] =
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
                              newInventory['batch_inventory_id'] =
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
                          labelText: "Chọn nhà cung cấp",
                          hintText: "country in menu mode",
                        ),
                      ),
                      onChanged: (e) {
                        newInventory['supplier_id'] =
                            e?.split(':').elementAt(0);
                        print(e);
                      },
                      // selectedItem: "Brazil",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập mã thuốc';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newInventory['inventory_code'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập mã thuốc',
                        labelText: 'Nhập mã thuốc',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập các thành phần chính';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newInventory['main_ingredient'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập thành phần chính',
                        labelText: 'Nhập thành phần chính',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập nơi sản xuất';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newInventory['producer'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập nơi sản xuất',
                        labelText: 'Nhập nơi sản xuất',
                      ),
                    ),
                  ),
                  if (auth.employee['role'] == 'manager')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          showSelectedItems: true,
                          showSearchBox: true,
                        ),
                        items: List<String>.of(branches
                            .map((e) => e.id!.toString() + ": " + e.name!)),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Chọn chi nhánh cho thuốc",
                            hintText: "Chọn chi nhánh cho thuốc",
                          ),
                        ),
                        onChanged: (e) {
                          newInventory['branch_id'] =
                              e?.split(':').elementAt(0);
                          print(e);
                        },
                        // selectedItem: "Brazil",
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: txt,
                            readOnly: true,
                            decoration: InputDecoration(
                              enabled: false,
                              hintText: 'Tải lên ảnh sản phẩm',
                              labelText:
                                  'Bấm nút bên phải để tải lên ảnh sản phẩm',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: () {
                            try {
                              FilePicker.platform
                                  .pickFiles()
                                  .then((value) => setState(() {
                                        image_file = value!.files.single.bytes!;
                                        newInventory['image_name'] =
                                            value.files.single.name;
                                        txt.text = value.files.single.name;
                                      }));
                            } on Exception catch (e) {
                              print('Failed to pick image: $e');
                            }
                          },
                        ),
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
                          child: Text('Tạo sản phẩm mới',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            inventoryService
                                .createInventory(
                                    auth.employee['access_token'],
                                    newInventory,
                                    image_file,
                                    auth.employee['role'])
                                .then((value) => Navigator.pushReplacementNamed(
                                    context, '/inventory_page'))
                                .catchError((err) => print(err));
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
