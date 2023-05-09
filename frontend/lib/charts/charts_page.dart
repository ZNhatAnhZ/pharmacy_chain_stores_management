import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/home/drawer.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:medical_chain_manangement/models/charts/bar_chart_customer.dart';
import 'package:medical_chain_manangement/models/charts/bar_model.dart';
import 'package:medical_chain_manangement/services/statistics_service.dart';
import 'package:provider/provider.dart';

import '../models/charts/pie_model.dart';

class ChartPage extends StatefulWidget {
  _ChartPage createState() => _ChartPage();
}

class _ChartPage extends State<ChartPage> {
  StatisticsService statisticsService = StatisticsService();
  List<BarModel> barModelList_revenueOrder = List.empty();
  List<BarModel> barModelList_revenueImport = List.empty();
  List<BarModel> barModelList_countOrder = List.empty();
  List<BarModel> barModelList_countImport = List.empty();
  List<PieModel> pieModelList_countOrderStatus = List.empty();
  List<BarChartCustomer> barModelList_customerList = List.empty();

  bool isCalled = false;
  bool isCalled1 = false;
  bool isCalled2 = false;
  bool isCalled3 = false;
  bool isCalled4 = false;
  bool isCalled5 = false;

  void getRevenueOrder(AuthBlock auth) {
    if (isCalled == false && auth.isLoggedIn) {
      statisticsService
          .getRevenueOrder(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          barModelList_revenueOrder = List.from(result);
          isCalled = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getRevenueImport(AuthBlock auth) {
    if (isCalled1 == false && auth.isLoggedIn) {
      statisticsService
          .getRevenueImport(
              auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          barModelList_revenueImport = List.from(result);
          isCalled1 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getCountOrder(AuthBlock auth) {
    if (isCalled2 == false && auth.isLoggedIn) {
      statisticsService
          .getCountOrder(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          barModelList_countOrder = List.from(result);
          isCalled2 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getCountImport(AuthBlock auth) {
    if (isCalled3 == false && auth.isLoggedIn) {
      statisticsService
          .getCountImport(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          barModelList_countImport = List.from(result);
          isCalled3 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getCountStatus(AuthBlock auth) {
    if (isCalled4 == false && auth.isLoggedIn) {
      statisticsService
          .getCountStatus(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          pieModelList_countOrderStatus = List.from(result);
          isCalled4 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  void getCustomerRanking(AuthBlock auth) {
    if (isCalled5 == false && auth.isLoggedIn) {
      statisticsService
          .getTopCustomers(auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          barModelList_customerList = List.from(result);
          isCalled5 = true;
        });
      }).catchError((err) {
        print(err);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    if (auth.employee['role'] != 'customer' &&
        auth.employee['role'] != 'admin') {
      getRevenueOrder(auth);
      getRevenueImport(auth);
      getCountImport(auth);
      getCountOrder(auth);
      getCountStatus(auth);
      getCustomerRanking(auth);
    }

    return Scaffold(
      drawer: Drawer(
        child: AppDrawer(),
      ),
      appBar: AppBar(
        title: Text("Biểu đồ"),
      ),
      body: auth.isLoggedIn
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Trạng thái tất cả các đơn: ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 600),
                        child: Text(
                          'Top 10 khách hàng mua nhiều nhất: ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 300,
                          width: 600,
                          child: charts.PieChart<String>([
                            charts.Series<PieModel, String>(
                              data: pieModelList_countOrderStatus,
                              id: 'asd',
                              // colorFn: (_, __) =>
                              //     charts.MaterialPalette.teal.shadeDefault,
                              domainFn: (PieModel pieModel, _) =>
                                  pieModel.status,
                              measureFn: (PieModel pieModel, _) =>
                                  pieModel.count,
                              labelAccessorFn: (PieModel row, _) =>
                                  '${row.status}: ${row.count}',
                            )
                          ],
                              animate: true,
                              defaultRenderer: new charts.ArcRendererConfig(
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                        labelPosition:
                                            charts.ArcLabelPosition.outside)
                                  ])),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 300,
                          width: 600,
                          child: charts.BarChart(
                            [
                              charts.Series<BarChartCustomer, String>(
                                data: barModelList_customerList,
                                id: 'asd',
                                // colorFn: (_, __) =>
                                //     charts.MaterialPalette.teal.shadeDefault,
                                domainFn: (BarChartCustomer pieModel, _) =>
                                    pieModel.name,
                                measureFn: (BarChartCustomer pieModel, _) =>
                                    pieModel.order_number,
                                labelAccessorFn: (BarChartCustomer row, _) =>
                                    '${row.name}: ${row.order_number} đơn',
                              )
                            ],
                            animate: true,
                            vertical: false,
                            barRendererDecorator:
                                new charts.BarLabelDecorator<String>(),
                            domainAxis: new charts.OrdinalAxisSpec(
                                renderSpec: new charts.NoneRenderSpec()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Doanh thu theo tháng: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width - 50,
                      child: charts.BarChart(
                        [
                          charts.Series<BarModel, String>(
                            data: barModelList_revenueOrder,
                            id: 'sales',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.purple.shadeDefault,
                            domainFn: (BarModel barModel, _) =>
                                "Tháng " + barModel.date,
                            measureFn: (BarModel barModel, _) =>
                                barModel.revenue,
                          )
                        ],
                        animate: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Giá trị nhập theo tháng: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width - 50,
                      child: charts.BarChart(
                        [
                          charts.Series<BarModel, String>(
                            data: barModelList_revenueImport,
                            id: 'sales',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.yellow.shadeDefault,
                            domainFn: (BarModel barModel, _) =>
                                "Tháng " + barModel.date,
                            measureFn: (BarModel barModel, _) =>
                                barModel.revenue,
                          )
                        ],
                        animate: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Số lượng đơn theo tháng: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width - 50,
                      child: charts.BarChart(
                        [
                          charts.Series<BarModel, String>(
                            data: barModelList_countOrder,
                            id: 'sales',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.indigo.shadeDefault,
                            domainFn: (BarModel barModel, _) =>
                                "Tháng " + barModel.date,
                            measureFn: (BarModel barModel, _) =>
                                barModel.revenue,
                          )
                        ],
                        animate: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Số lượng nhập theo tháng: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width - 50,
                      child: charts.BarChart(
                        [
                          charts.Series<BarModel, String>(
                            data: barModelList_countImport,
                            id: 'sales',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.teal.shadeDefault,
                            domainFn: (BarModel barModel, _) =>
                                "Tháng " + barModel.date,
                            measureFn: (BarModel barModel, _) =>
                                barModel.revenue,
                          )
                        ],
                        animate: true,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://i.ibb.co/qpNZ52M/pharmacy.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }
}
