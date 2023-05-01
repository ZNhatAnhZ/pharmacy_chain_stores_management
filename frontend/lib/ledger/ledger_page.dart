import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/ledger.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/services/branch_service.dart';
import 'package:medical_chain_manangement/services/ledger_service.dart';
import 'package:provider/provider.dart';

class LedgerPage extends StatefulWidget {
  @override
  _LedgerPage createState() => _LedgerPage();
}

class _LedgerPage extends State<LedgerPage> {
  LedgerService ledgerService = LedgerService();
  BranchService branchService = BranchService();
  List<Ledger> ledgers = List.empty();
  List<Branch> branches = List.empty();

  bool isCalled = false;
  bool isCalled1 = false;

  void getAllLedger(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      ledgerService
          .getAllLedger(auth.employee['access_token'], auth.employee['role'],
              branch_value, dates)
          .then((result) {
        setState(() {
          ledgers = List.from(result);
          isCalled = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getAllBranch(AuthBlock auth) {
    if (isCalled1 == false && auth.isLoggedIn) {
      branchService
          .getAllBranch(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          result.add(Branch(id: -1, name: 'All branches'));
          branches = List.from(result);
          isCalled1 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  Map<String, String> dates = {'start_date': '', 'end_date': ''};
  String branch_value = '-1';

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    getAllLedger(auth);
    getAllBranch(auth);

    return Scaffold(
      appBar: AppBar(
        actions: [
          const Padding(
            padding: EdgeInsets.only(
              left: 60,
              top: 15,
              bottom: 10,
            ),
            child: Text(
              "Sổ quỹ",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  final values = await showCalendarDatePicker2Dialog(
                    context: context,
                    config: CalendarDatePicker2WithActionButtonsConfig(
                      calendarType: CalendarDatePicker2Type.range,
                    ),
                    dialogSize: const Size(325, 400),
                    borderRadius: BorderRadius.circular(15),
                    dialogBackgroundColor: Colors.white,
                  );
                  if (values != null) {
                    bool flag = true;
                    values.forEach((element) {
                      if (flag) {
                        dates['start_date'] =
                            element.toString().substring(0, 10);
                        flag = false;
                      } else {
                        dates['end_date'] = element.toString().substring(0, 10);
                      }
                    });
                  } else {
                    dates['start_date'] = '';
                    dates['end_date'] = '';
                  }
                  print(values);

                  if (auth.isLoggedIn) {
                    ledgerService
                        .getAllLedger(auth.employee['access_token'],
                            auth.employee['role'], branch_value, dates)
                        .then((result) {
                      setState(() {
                        ledgers = List.from(result);
                        isCalled = true;
                      });
                    }).catchError((err) {
                      print(err);
                    });
                  }
                },
                child: const Text('Lọc theo khoảng thời gian'),
              ),
            ),
          ),
          if (auth.isLoggedIn && auth.employee['role'] == 'manager')
            Padding(
                padding: EdgeInsets.only(
                  right: 60,
                  top: 15,
                  bottom: 10,
                ),
                child: DropdownButton<int>(
                  value: int.parse(branch_value),
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  onChanged: (int? value) {
                    if (auth.isLoggedIn) {
                      ledgerService
                          .getAllLedger(auth.employee['access_token'],
                              auth.employee['role'], value.toString(), dates)
                          .then((result) {
                        setState(() {
                          ledgers = List.from(result);
                          branch_value = value.toString();
                        });
                      }).catchError((err) {
                        print(err);
                      });
                    }
                  },
                  items: branches.map<DropdownMenuItem<int>>((Branch value) {
                    return DropdownMenuItem<int>(
                      value: value.id,
                      child: Text(value.name!),
                    );
                  }).toList(),
                )),
          IconButton(
            icon: const Icon(Icons.download_sharp),
            onPressed: () {
              ledgerService.exportLedgerCSV(auth.employee['access_token'],
                  auth.employee['role'], branch_value);
            },
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: DataTable(
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(
                          label: Text("Mã giao dịch"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Loại giao dịch"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Tổng tiền"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Ngày tạo"),
                          numeric: false,
                        ),
                      ],
                      rows: ledgers
                          .map(
                            (ledger) => DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    ledger.code!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    ledger.type!,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    ledger.revenue.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    ledger.created_date!,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
