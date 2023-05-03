import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:medical_chain_manangement/services/employee_service.dart';
import 'package:provider/provider.dart';

class EmployeeDetail extends StatefulWidget {
  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  EmployeeService employeeService = EmployeeService();

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    final Employee employee =
        ModalRoute.of(context)!.settings.arguments as Employee;
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem chi tiết nhân viên'),
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
                            initialValue: "ID: " + employee.id.toString(),
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
                            initialValue: "Tên: " + employee.name!,
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
                            initialValue: "Email: " + employee.email!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (auth.employee['role'] == "admin")
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: "Vai trò: " + employee.role!,
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
                                  child: Text('Sửa thông tin',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/employee_modify',
                                        arguments: employee);
                                  },
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  child: Text('Xóa nhân viên',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    employeeService
                                        .deleteEmployee(
                                            auth.employee['access_token'],
                                            employee.id.toString(),
                                            auth.employee['role'])
                                        .then((value) =>
                                            Navigator.pushReplacementNamed(
                                                context, '/employee_page'))
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
                    width: 500,
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
                                "Branch ID: " + employee.branch_id.toString(),
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
                            initialValue: "Địa chỉ: " + employee.address!,
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
                            initialValue: "Giới tính: " + employee.gender!,
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
                            initialValue: "Số điện thoại: " + employee.contact!,
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
