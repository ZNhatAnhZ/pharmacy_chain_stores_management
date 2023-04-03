import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/inventory.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medical_chain_manangement/services/inventory_service.dart';
import 'package:medical_chain_manangement/services/order_service.dart';
import 'package:provider/provider.dart';

class SellingDrug extends StatefulWidget {
  @override
  _SellingDrugState createState() => _SellingDrugState();
}

class _SellingDrugState extends State<SellingDrug> {
  InventoryService inventoryService = InventoryService();
  OrderService orderService = OrderService();

  List<Inventory> inventorys = List.empty();

  bool isCalled = false;

  void getAllInventory(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      inventoryService
          .getAllInventory(auth.employee['access_token'], auth.employee['role'], '')
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

  Map newOrder = {};

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    getAllInventory(auth);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bán hàng"),
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
                              newOrder['inventory_id'] =
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
                          newOrder['total_price'] = value;
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
                          return 'Hãy nhập số lượng';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newOrder['total_quantity'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập số lượng',
                        labelText: 'Nhập số lượng',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập tên khách hàng';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newOrder['customer_name'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập tên khách hàng',
                        labelText: 'Hãy nhập tên khách hàng',
                      ),
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
                          child: Text('Thanh toán',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            orderService
                                .createOrder(
                                    auth.employee['access_token'], newOrder)
                                .then((value) => null)
                                .catchError((err) => print(err));
                          },
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
