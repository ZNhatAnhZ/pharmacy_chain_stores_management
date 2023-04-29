import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // void initialize_employee_value(Employee employee) {
  //   if (isCalled && isCalled1 == false) {
  //     branches.forEach((branch) {
  //       if (branch.id == employee.branch_id) {
  //         selectedBranch = branch.id.toString() + ": " + branch.name!;
  //       }
  //     });

  //     newEmployee['id'] = employee.id.toString();
  //     newEmployee['name'] = employee.name!;
  //     newEmployee['email'] = employee.email!;
  //     newEmployee['branch_id'] = employee.branch_id.toString();

  //     isCalled1 = true;
  //   }
  // }

  Map newEmployee = {};
  String selectedBranch = '';

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);

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
                      // initialValue: employee.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nhập tên tài khoản';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newEmployee['name'] = value;
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
                          onPressed: () {},
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
