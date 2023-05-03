import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:medical_chain_manangement/services/employee_service.dart';
import 'package:provider/provider.dart';

class EmployeeModify extends StatefulWidget {
  @override
  _EmployeeModifyState createState() => _EmployeeModifyState();
}

class _EmployeeModifyState extends State<EmployeeModify> {
  EmployeeService employeeService = EmployeeService();
  BranchService branchService = BranchService();
  List<Branch> branches = List.empty();

  bool isCalled = false;
  bool isCalled1 = false;

  void getAllBranch(AuthBlock auth) {
    if (isCalled == false &&
        auth.isLoggedIn &&
        (auth.employee['role'] == "manager" ||
            auth.employee['role'] == "admin")) {
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
    } else {
      setState(() {
        isCalled = true;
      });
    }
  }

  void initialize_employee_value(Employee employee) {
    if (isCalled && isCalled1 == false) {
      branches.forEach((branch) {
        if (branch.id == employee.branch_id) {
          selectedBranch = branch.id.toString() + ": " + branch.name!;
        }
      });

      newEmployee['id'] = employee.id.toString();
      newEmployee['name'] = employee.name!;
      newEmployee['email'] = employee.email!;
      newEmployee['contact'] = employee.contact!;
      newEmployee['gender'] = employee.gender!;
      newEmployee['address'] = employee.address!;
      newEmployee['role'] = employee.role!;
      newEmployee['branch_id'] = employee.branch_id.toString();

      isCalled1 = true;
    }
  }

  Map newEmployee = {};
  String selectedBranch = '';

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    final Employee employee =
        ModalRoute.of(context)!.settings.arguments as Employee;
    getAllBranch(auth);
    initialize_employee_value(employee);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sửa thông tin nhân viên"),
      ),
      body: Center(
        child: Form(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (auth.employee["role"] == "manager" ||
                      auth.employee["role"] == "admin")
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
                              items: List<String>.of(branches.map(
                                  (e) => e.id!.toString() + ": " + e.name!)),
                              selectedItem: selectedBranch,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Chọn chi nhánh",
                                  hintText: "Chọn chi nhánh",
                                ),
                              ),
                              onChanged: (e) {
                                newEmployee['branch_id'] =
                                    e?.split(':').elementAt(0);
                                print(e);
                              },
                              // selectedItem: "Brazil",
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () {
                              Navigator.pushNamed(context, '/add_branch');
                            },
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      initialValue: employee.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập tên nhân viên';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newEmployee['name'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập tên nhân viên',
                        labelText: 'Nhập tên nhân viên',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      initialValue: employee.email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newEmployee['email'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập email',
                        labelText: 'Nhập email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      initialValue: employee.contact,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập số điện thoại';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newEmployee['contact'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập số điện thoại',
                        labelText: 'Hãy nhập số điện thoại',
                      ),
                    ),
                  ),
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
                            items: List.unmodifiable(['male', 'female']),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Hãy nhập giới tính",
                                hintText: "Hãy nhập giới tính",
                              ),
                            ),
                            onChanged: (e) {
                              newEmployee['gender'] = e;
                              print(e);
                            },
                            selectedItem: employee.gender,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (auth.employee['role'] == 'admin')
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
                              items: List.unmodifiable(
                                  ['manager', 'store_owner', 'employee']),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Hãy nhập vai trò",
                                  hintText: "Hãy nhập vai trò",
                                ),
                              ),
                              onChanged: (e) {
                                newEmployee['role'] = e;
                                print(e);
                              },
                              selectedItem: employee.role,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      initialValue: employee.address,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập địa chỉ';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newEmployee['address'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập địa chỉ',
                        labelText: 'Hãy nhập địa chỉ',
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
                          child: Text('Submit',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            employeeService
                                .updateEmployee(auth.employee['access_token'],
                                    newEmployee, auth.employee['role'])
                                .then((value) => Navigator.pushReplacementNamed(
                                    context, '/employee_page'))
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
