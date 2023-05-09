import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/inventory.dart';
import 'package:medical_chain_manangement/services/inventory_service.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/order_service.dart';
import 'number_input.dart';

class InventoryDetail extends StatefulWidget {
  @override
  State<InventoryDetail> createState() => _InventoryDetailState();
}

class _InventoryDetailState extends State<InventoryDetail> {
  InventoryService inventoryService = InventoryService();
  OrderService orderService = OrderService();
  TextEditingController quantityController = TextEditingController();
  Map newOrder = {};

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    quantityController.text = '1';
    final Inventory inventory =
        ModalRoute.of(context)!.settings.arguments as Inventory;
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem chi tiết sản phẩm'),
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 25),
                    child: SizedBox(
                      width: 500,
                      height: 50,
                      child: TextFormField(
                        readOnly: true,
                        initialValue: "Tên sản phẩm: " + inventory.name!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    height: 500,
                    child: Image.network(inventory.image!),
                  ),
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 400,
                    height: 700,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "ID: " + inventory.id.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Giá: " + inventory.price.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue:
                                "Đơn vị: " + inventory.inventory_type!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue:
                                "Số lượng: " + inventory.quantity.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue:
                                "Mã hàng: " + inventory.inventory_code!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (auth.employee['role'] != 'customer')
                          Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 25, top: 10),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    child: Text('Sửa inventory',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/inventory_detail_modify',
                                          arguments: inventory);
                                    },
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: Text('Xóa sản phẩm',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      inventoryService
                                          .deleteInventory(
                                              auth.employee['access_token'],
                                              inventory.id.toString(),
                                              auth.employee['role'])
                                          .then((value) =>
                                              Navigator.pushReplacementNamed(
                                                  context, '/inventory_page'))
                                          .catchError((err) => print(err));
                                    },
                                  )
                                ],
                              )),
                        if (auth.employee['role'] == 'customer')
                          Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 160,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.shopping_bag_rounded),
                                            Text('Mua thuốc',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            newOrder['inventory_id'] =
                                                inventory.id.toString();
                                            newOrder['customer_id'] = auth
                                                .employee['customer_id']
                                                .toString();
                                            newOrder['total_quantity'] =
                                                quantityController.text;
                                            newOrder['total_price'] =
                                                (int.parse(quantityController
                                                            .text) *
                                                        inventory.price!)
                                                    .toString();
                                          });

                                          orderService
                                              .createOrder(
                                                  auth.employee['access_token'],
                                                  newOrder,
                                                  auth.employee['role'])
                                              .then((value) {
                                            quantityController.text = '1';
                                          }).catchError((err) => print(err));
                                        }),
                                  ),
                                  SizedBox(
                                    width: 80,
                                  ),
                                  Expanded(
                                    child: NumberTextField(
                                      controller: quantityController,
                                    ),
                                  ),
                                ],
                              )),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 500,
                    height: 700,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Thành phần chính: " +
                                inventory.main_ingredient!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue:
                                "Nơi sản xuất: " + inventory.producer!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Chi nhánh: " +
                                inventory.branch!.id.toString() +
                                ". " +
                                inventory.branch!.name!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Thể loại: " +
                                inventory.category!.id.toString() +
                                ". " +
                                inventory.category!.name!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Lô sản phẩm: " +
                                inventory.batch_inventory!.id.toString() +
                                ". " +
                                inventory.batch_inventory!.batch_code!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Người cung cấp: " +
                                inventory.supplier!.id.toString() +
                                ". " +
                                inventory.supplier!.name!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
