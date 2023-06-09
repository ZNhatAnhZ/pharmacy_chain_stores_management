import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medical_chain_manangement/services/forgot_password_service.dart';
import 'package:provider/provider.dart';

import '../home/drawer.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ForgotPasswordService forgotPasswordService = ForgotPasswordService();
  bool isCalled = false;
  void intializeName(AuthBlock auth) {
    if (isCalled == false && auth.employee['role'] == 'customer') {
      data['name'] = auth.employee['customer_name'];
      data['contact'] = auth.employee['customer_contact'];
      data['gender'] = auth.employee['customer_gender'];
      data['address'] = auth.employee['customer_address'];
      isCalled = true;
    } else if (isCalled == false && auth.employee['role'] != 'customer') {
      data['name'] = auth.employee['employee_name'];
      data['contact'] = auth.employee['employee_contact'];
      data['gender'] = auth.employee['employee_gender'];
      data['address'] = auth.employee['employee_address'];
      isCalled = true;
    }
  }

  Map data = {};

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    intializeName(auth);

    return Scaffold(
      drawer: Drawer(
        child: AppDrawer(),
      ),
      appBar: AppBar(
        title: const Text("Sửa thông tin tài khoản"),
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
                    child: TextFormField(
                      // initialValue: employee.email,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập mật khẩu cũ';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          data['old_password'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập mật khẩu cũ',
                        labelText: 'Hãy nhập mật khẩu cũ',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      initialValue: data['name'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nhập tên tài khoản';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          data['name'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập tên tài khoản',
                        labelText: 'Nhập tên tài khoản',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      // initialValue: employee.email,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập mật khẩu mới';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          data['new_password'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập mật khẩu mới',
                        labelText: 'Hãy nhập mật khẩu mới',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      initialValue: data['contact'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập số điện thoại';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          data['contact'] = value;
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
                    child: TextFormField(
                      initialValue: data['address'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập địa chỉ';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          data['address'] = value;
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
                              data['gender'] = e;
                              print(e);
                            },
                            selectedItem: data['gender'],
                          ),
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
                          child: Text('Xác nhận',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (data.length < 6) {
                              Fluttertoast.showToast(
                                  msg: "Cập nhật thông tin thất bại",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  webBgColor:
                                      "linear-gradient(to right, #dc1c13, #dc1c13)",
                                  fontSize: 16.0);
                            } else {
                              EmployeeCredential employeeCredential =
                                  EmployeeCredential(email: '', password: '');
                              employeeCredential.email =
                                  auth.employee['role'] == 'customer'
                                      ? auth.employee['customer_email']
                                      : auth.employee['employee_email'];
                              employeeCredential.password =
                                  data['new_password'];
                              forgotPasswordService
                                  .updateAccountInfo(
                                    data,
                                    auth.employee['role'],
                                    auth.employee['employee_id'].toString(),
                                    auth.employee['access_token'],
                                  )
                                  .then((value) => {
                                        if (value &&
                                            auth.employee['role'] != 'customer')
                                          {
                                            auth
                                                .employeeLogin(
                                                    employeeCredential)
                                                .then((e) {
                                              Navigator.pushReplacementNamed(
                                                  context, '/');
                                            })
                                          }
                                        else if (value &&
                                            auth.employee['role'] == 'customer')
                                          {
                                            auth
                                                .customerLogin(
                                                    employeeCredential)
                                                .then((e) {
                                              Navigator.pushReplacementNamed(
                                                  context, '/inventory_page');
                                            })
                                          }
                                      });
                            }
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
