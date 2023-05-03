import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/models/order.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:medical_chain_manangement/services/order_service.dart';
import 'package:provider/provider.dart';

class TransactionOut extends StatefulWidget {
  @override
  _TransactionOut createState() => _TransactionOut();
}

class _TransactionOut extends State<TransactionOut> {
  OrderService orderService = OrderService();
  List<Order> orders = List.empty();
  BranchService branchService = BranchService();
  List<Branch> branches = List.empty();

  bool isCalled = false;
  bool isCalled1 = false;

  void getAllOrder(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      orderService
          .getAllOrder(auth.employee['access_token'],
              auth.employee['role'], '', dates)
          .then((result) {
        setState(() {
          orders = List.from(result);
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
    final scrollController = ScrollController();
    AuthBlock auth = Provider.of<AuthBlock>(context);
    getAllOrder(auth);
    if (auth.employee['role'] != 'customer') {
      getAllBranch(auth);
    }

    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        const Padding(
          padding: EdgeInsets.only(
            left: 60,
            top: 15,
            bottom: 10,
          ),
          child: Text(
            "Giao dịch ra",
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
                  orderService
                      .getAllOrder(auth.employee['access_token'],
                          auth.employee['role'], branch_value, dates)
                      .then((result) {
                    setState(() {
                      orders = List.from(result);
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
                    orderService
                        .getAllOrder(auth.employee['access_token'],
                            auth.employee['role'], value.toString(), dates)
                        .then((result) {
                      setState(() {
                        orders = List.from(result);
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
        if (auth.employee['role'] != 'customer')
          IconButton(
            icon: const Icon(Icons.download_sharp),
            onPressed: () {
              orderService.exportOrderCSV(auth.employee['access_token'],
                  auth.employee['role'], branch_value);
            },
          ),
      ]),
      body: Row(
        children: <Widget>[
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
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
                            label: Text("Tổng tiền"),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Text("Mã đơn"),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Text("Tên khách hàng"),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Text("Tên hàng"),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text("Mã hàng"),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text("Tên nhà sản xuất"),
                            numeric: false,
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
                        rows: orders
                            .map(
                              (product) => DataRow(
                                onSelectChanged: (value) {
                                  Navigator.pushNamed(
                                      context, '/transaction_out_detail',
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
                                      product.total_price.toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product.order_code!,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product.customer!.name!,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product.inventory!.name!,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product.inventory!.inventory_code!,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product.inventory!.producer!,
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
                ),
              )),
        ],
      ),
    );
  }
}
