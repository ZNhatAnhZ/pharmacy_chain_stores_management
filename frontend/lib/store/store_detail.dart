import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:provider/provider.dart';

class StoreDetail extends StatefulWidget {
  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  BranchService branchService = BranchService();

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    final Branch branch = ModalRoute.of(context)!.settings.arguments as Branch;
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem chi tiết chi nhánh'),
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 400,
                    height: 700,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "ID: " + branch.id.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Tên: " + branch.name!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Address: " + branch.address!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 25, top: 10),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  child: Text('Sửa thông tin chi nhánh',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/store_modify',
                                        arguments: branch);
                                  },
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  child: Text('Xóa chi nhánh',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    branchService
                                        .deleteBranch(
                                            auth.employee['access_token'],
                                            branch.id.toString(),
                                            auth.employee['role'])
                                        .then((value) =>
                                            Navigator.pushReplacementNamed(
                                                context, '/store'))
                                        .catchError((err) => print(err));
                                  },
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 400,
                    height: 700,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue:
                                "Mã chi nhánh: " + branch.branch_code!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Email: " + branch.email!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "Số điện thoại: " + branch.contact!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
