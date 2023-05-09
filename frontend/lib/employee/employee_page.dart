import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:medical_chain_manangement/services/employee_service.dart';
import 'package:provider/provider.dart';

import '../home/drawer.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePage createState() => _EmployeePage();
}

class _EmployeePage extends State<EmployeePage> {
  EmployeeService employeeService = EmployeeService();
  List<Employee> employees = List.empty();
  BranchService branchService = BranchService();
  List<Branch> branches = List.empty();

  bool isCalled = false;
  bool isCalled1 = false;

  void getAllEmployee(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      employeeService
          .getAllEmployee(auth.employee['access_token'], auth.employee['role'],
              branch_value)
          .then((result) {
        setState(() {
          employees = List.from(result);
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
          result.add(Branch(id: -1, name: 'Tất cả các chi nhánh'));
          branches = List.from(result);
          isCalled1 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  String branch_value = '-1';

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    getAllEmployee(auth);
    getAllBranch(auth);

    return Scaffold(
      drawer: Drawer(
        child: AppDrawer(),
      ),
      appBar: AppBar(title: const Text("Quản lý nhân viên"), actions: <Widget>[
        if (auth.employee["role"] == "manager")
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
                    employeeService
                        .getAllEmployee(auth.employee['access_token'],
                            auth.employee['role'], value.toString())
                        .then((result) {
                      setState(() {
                        employees = List.from(result);
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
        if (auth.employee['role'] != "admin")
          IconButton(
            icon: const Icon(Icons.download_sharp),
            onPressed: () {
              employeeService.exportEmployeeCSV(auth.employee['access_token'],
                  auth.employee['role'], branch_value);
            },
          ),
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: () {
            Navigator.pushNamed(context, '/employee_add');
          },
        )
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
                          label: Text("Tên"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Email"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("ID chi nhánh"),
                          numeric: false,
                        ),
                        if (auth.employee['role'] == "admin")
                          DataColumn(
                            label: Text("Vai trò"),
                            numeric: false,
                          ),
                      ],
                      rows: employees
                          .map(
                            (employee) => DataRow(
                              onSelectChanged: (value) {
                                Navigator.pushNamed(context, '/employee_detail',
                                    arguments: employee);
                              },
                              cells: [
                                DataCell(
                                  Text(
                                    employee.id.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    employee.name!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    employee.email!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    employee.branch_id.toString(),
                                  ),
                                ),
                                if (auth.employee['role'] == "admin")
                                  DataCell(
                                    Text(
                                      employee.role!,
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
