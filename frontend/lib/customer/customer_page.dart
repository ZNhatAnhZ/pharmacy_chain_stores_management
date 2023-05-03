import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/customer.dart';
import 'package:medical_chain_manangement/services/customer_service.dart';
import 'package:provider/provider.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPage createState() => _CustomerPage();
}

class _CustomerPage extends State<CustomerPage> {
  CustomerService customerService = CustomerService();
  List<Customer> customers = List.empty();

  bool isCalled = false;

  void getAllCustomers(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      customerService
          .getAllCustomer(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          customers = List.from(result);
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
    getAllCustomers(auth);

    return Scaffold(
      appBar: AppBar(
        title: Text("Tất cả các khách hàng"),
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
                          label: Text("Tên"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Email"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Số điện thoại"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Địa chỉ"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Giới tính"),
                          numeric: false,
                        ),
                      ],
                      rows: customers
                          .map(
                            (customer) => DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    customer.id.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    customer.name!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    customer.email!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    customer.contact!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    customer.address!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    customer.gender!,
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
