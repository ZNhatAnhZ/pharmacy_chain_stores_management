import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/batch_inventory.dart';
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

  List<Inventory> inventorys = List.empty();
  List<BatchInventory> batchInventory = List.empty();
  List<Supplier> supplier = List.empty();
  List<Category> categories = List.empty();

  bool isCalled = false;
  bool isCalled1 = false;
  bool isCalled2 = false;
  bool isCalled3 = false;

  void getAllInventory(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      inventoryService
          .getAllInventory(
              auth.employee['access_token'], auth.employee['access_token'], '')
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

  void getAllCategory(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
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

  final _formKey = GlobalKey<FormState>();
  Map newInventory = {};
  Map newBatchInventory = {};
  late Uint8List image_file;

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    getAllInventory(auth);
    getAllBatchInventory(auth);
    getAllSupplier(auth);
    getAllCategory(auth);

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
                          labelText: "Chọn loại thuốc",
                          hintText: "Chọn loại thuốc",
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
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Hãy nhập ngày hết hạn';
                                            }
                                            return null;
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
                                                            'expired_date'])
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
                          labelText: "Chọn nhà sản xuất",
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
                              hintText: 'Upload ảnh sản phẩm',
                              labelText:
                                  'Bấm nút bên phải để upload ảnh sản phẩm',
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
                          child: Text('Tạo inventory mới',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            inventoryService
                                .createInventory(auth.employee['access_token'],
                                    newInventory, image_file)
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
