import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medical_chain_manangement/models/supplier.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:medical_chain_manangement/services/employee_service.dart';
import 'package:medical_chain_manangement/services/supplier_service.dart';
import 'package:provider/provider.dart';

class AddPartner extends StatefulWidget {
  @override
  _AddPartnerState createState() => _AddPartnerState();
}

class _AddPartnerState extends State<AddPartner> {
  SupplierService supplierService = SupplierService();

  Map newSupplier = {};

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo nhà cung cấp"),
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
                          return 'Hãy nhập tên nhà cung cấp';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newSupplier['name'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Hãy nhập tên nhà cung cấp',
                        labelText: 'Hãy nhập tên nhà cung cấp',
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
                          newSupplier['contact'] = value;
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Hãy nhập email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newSupplier['email'] = value;
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
                          return 'Hãy nhập địa chỉ';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newSupplier['address'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Nhập địa chỉ',
                        labelText: 'Nhập địa chỉ',
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
                            supplierService
                                .createSupplier(auth.employee['access_token'],
                                    newSupplier, auth.employee['role'])
                                .then((value) => Navigator.pushReplacementNamed(
                                    context, '/partner'))
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
