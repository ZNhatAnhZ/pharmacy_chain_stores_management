import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:provider/provider.dart';

import '../home/drawer.dart';

class Store extends StatefulWidget {
  @override
  _Store createState() => _Store();
}

class _Store extends State<Store> {
  BranchService branchService = BranchService();
  List<Branch> branches = List.empty();

  bool isCalled = false;

  void getAllBranches(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      branchService
          .getAllBranch(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          branches = List.from(result);
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
    getAllBranches(auth);

    return Scaffold(
            drawer: Drawer(
        child: AppDrawer(),
      ),
      appBar: AppBar(
        title: Text("Tất cả các chi nhánh"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/store_add');
            },
          )
        ],
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
                          label: Text("Tên chi nhánh"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Địa chỉ"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Mã chi nhánh"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Email chi nhánh"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Số điện thoại"),
                          numeric: false,
                        ),
                      ],
                      rows: branches
                          .map(
                            (branch) => DataRow(
                              onSelectChanged: (value) {
                                Navigator.pushNamed(context, '/store_detail',
                                    arguments: branch);
                              },
                              cells: [
                                DataCell(
                                  Text(
                                    branch.id.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    branch.name!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    branch.address!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    branch.branch_code!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    branch.email!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    branch.contact!,
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
