import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:provider/provider.dart';

import '../models/branch.dart';

class StoreModify extends StatefulWidget {
  @override
  _StoreModifyState createState() => _StoreModifyState();
}

class _StoreModifyState extends State<StoreModify> {
  BranchService branchService = BranchService();

  bool isCalled = false;

  void initialize_branch_value(Branch branch) {
    if (isCalled == false) {
      newBranch['name'] = branch.name!;
      newBranch['address'] = branch.address!;
      newBranch['branch_code'] = branch.branch_code!;
      newBranch['email'] = branch.email!;
      newBranch['contact'] = branch.contact!;
      newBranch['id'] = branch.id.toString();

      isCalled = true;
    }
  }

  Map newBranch = {};

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    final Branch branch = ModalRoute.of(context)!.settings.arguments as Branch;
    initialize_branch_value(branch);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sửa thông tin chi nhánh"),
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
                      initialValue: newBranch['name'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập tên chi nhánh';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newBranch['name'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập tên chi nhánh',
                        labelText: 'Hãy nhập tên chi nhánh',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      initialValue: newBranch['address'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập địa chỉ chi nhánh';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newBranch['address'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập địa chỉ chi nhánh',
                        labelText: 'Hãy nhập địa chỉ chi nhánh',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      initialValue: newBranch['branch_code'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập mã chi nhánh';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newBranch['branch_code'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập mã chi nhánh',
                        labelText: 'Hãy nhập mã chi nhánh',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      initialValue: newBranch['email'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newBranch['email'] = value;
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
                      initialValue: newBranch['contact'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập số điện thoại';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newBranch['contact'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập số điện thoại',
                        labelText: 'Nhập số điện thoại',
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
                          child: Text('Sửa chi nhánh',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            branchService
                                .updateBranch(auth.employee['access_token'],
                                    newBranch, auth.employee['role'])
                                .then((value) => Navigator.pushReplacementNamed(
                                    context, '/store'))
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
