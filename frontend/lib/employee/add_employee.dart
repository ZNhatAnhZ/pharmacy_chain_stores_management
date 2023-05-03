import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:medical_chain_manangement/services/employee_service.dart';
import 'package:provider/provider.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  EmployeeService employeeService = EmployeeService();
  BranchService branchService = BranchService();
  List<Branch> branches = List.empty();

  bool isCalled = false;

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
    }
  }

  Map newEmployee = {};

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    getAllBranch(auth);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo nhân viên"),
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
                      auth.employee['role'] == "admin")
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
                          if (auth.employee["role"] == "manager")
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
                            // selectedItem: "Brazil",
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
                              // selectedItem: "Brazil",
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
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
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập mật khẩu';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newEmployee['password'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập mật khẩu',
                        labelText: 'Nhập mật khẩu',
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
                                .createEmployee(auth.employee['access_token'],
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
