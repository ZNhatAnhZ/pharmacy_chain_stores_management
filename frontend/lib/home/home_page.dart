import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/home/drawer.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:medical_chain_manangement/models/charts/bar_model.dart';
import 'package:medical_chain_manangement/models/charts/header_statistic.dart';
import 'package:medical_chain_manangement/services/headerStatistic_service.dart';
import 'package:medical_chain_manangement/services/statistics_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  StatisticsService statisticsService = StatisticsService();
  HeaderStatisticService headerStatisticService = HeaderStatisticService();
  List<BarModel> barModelList_revenueOrder = List.empty();
  HeaderStatistic headerStatistic = HeaderStatistic();

  bool isCalled = false;
  bool isCalled1 = false;

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

  void getAllHeaderStatistic(AuthBlock auth) {
    if (isCalled1 == false && auth.isLoggedIn) {
      headerStatisticService
          .getAllHeaderStatistic(
              auth.employee['access_token'], auth.employee['role'])
          .then((result) {
        setState(() {
          headerStatistic = result;
          isCalled1 = true;
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
      getAllHeaderStatistic(auth);
      getRevenueOrder(auth);
    }

    return Scaffold(
      drawer: Drawer(
        child: AppDrawer(),
      ),
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: auth.isLoggedIn &&
              auth.employee['role'] != 'customer' &&
              auth.employee['role'] != 'admin'
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 300,
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Doanh thu tháng này',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    headerStatistic.order_month_count
                                            .toString() +
                                        ' Hóa đơn',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    headerStatistic.order_month_price
                                            .toString() +
                                        ' VND',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 35,
                                bottom: 5,
                              ),
                              child: Icon(
                                Icons.stacked_line_chart_sharp,
                                color: Colors.grey.shade300,
                                size: 70,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 300,
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Doanh thu so với tháng trước',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    '',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    headerStatistic
                                            .order_percent_from_last_month
                                            .toString() +
                                        " %",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 35,
                                bottom: 5,
                              ),
                              child: Icon(
                                Icons.stacked_line_chart_sharp,
                                color: Colors.grey.shade300,
                                size: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 300,
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Giá trị đơn nhập',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    headerStatistic
                                            .import_inventories_month_count
                                            .toString() +
                                        " Đơn",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    headerStatistic
                                            .import_inventories_month_price
                                            .toString() +
                                        ' VND',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 35,
                                bottom: 5,
                              ),
                              child: Icon(
                                Icons.stacked_line_chart_sharp,
                                color: Colors.grey.shade300,
                                size: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 300,
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Đơn nhập so với tháng trước',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    '',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    headerStatistic.im_percent_from_last_month
                                            .toString() +
                                        " %",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 35,
                                bottom: 5,
                              ),
                              child: Icon(
                                Icons.stacked_line_chart_sharp,
                                color: Colors.grey.shade300,
                                size: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
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
                  image: NetworkImage(
                      "https://i.ibb.co/HrbG0rq/home-background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }
}
