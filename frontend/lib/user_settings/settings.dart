import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medical_chain_manangement/services/forgot_password_service.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ForgotPasswordService forgotPasswordService = ForgotPasswordService();
  bool isCalled = false;
  void intializeName(String existname) {
    if (isCalled == false) {
      name = existname;
      isCalled = true;
    }
  }

  String old_password = '';
  String new_password = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    intializeName(auth.employee['employee_name']);

    return Scaffold(
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập mật khẩu cũ';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          old_password = value;
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
                      initialValue: name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nhập tên tài khoản';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          name = value;
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập mật khẩu mới';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          new_password = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập mật khẩu mới',
                        labelText: 'Hãy nhập mật khẩu mới',
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
                            EmployeeCredential employeeCredential =
                                EmployeeCredential(email: '', password: '');
                            employeeCredential.email =
                                auth.employee['employee_email'];
                            employeeCredential.password = new_password;
                            forgotPasswordService
                                .updateAccountInfo(
                                  name,
                                  old_password,
                                  new_password,
                                  auth.employee['role'],
                                  auth.employee['employee_id'].toString(),
                                  auth.employee['access_token'],
                                )
                                .then((value) => {
                                      if (value)
                                        {
                                          auth
                                              .employeeLogin(employeeCredential)
                                              .then((e) {
                                            Navigator.pop(context);
                                          })
                                        }
                                    });
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
