import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:provider/provider.dart';

class AddStore extends StatefulWidget {
  @override
  _AddStoreState createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  BranchService branchService = BranchService();

  Map newStore = {};

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo chi nhánh"),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập tên chi nhánh';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newStore['name'] = value;
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập địa chỉ';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newStore['address'] = value;
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
                          return 'Hãy nhập mã chi nhánh';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newStore['branch_code'] = value;
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newStore['email'] = value;
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
                          newStore['contact'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập số điện thoại',
                        labelText: 'Hãy nhập số điện thoại',
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
                          child: Text('Thêm chi nhánh',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            branchService
                                .createBranch(auth.employee['access_token'],
                                    newStore, auth.employee['role'])
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
