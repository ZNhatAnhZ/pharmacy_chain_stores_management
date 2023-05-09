import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:medical_chain_manangement/models/order.dart';
import 'package:medical_chain_manangement/services/order_service.dart';
import 'package:provider/provider.dart';

class TransactionOutDetail extends StatefulWidget {
  @override
  State<TransactionOutDetail> createState() => _TransactionOutDetailState();
}

class _TransactionOutDetailState extends State<TransactionOutDetail> {
  OrderService orderService = OrderService();
  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem chi tiết giao dịch ra'),
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
              Column(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 450,
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
                                "ID giao dịch ra: " + order.id.toString(),
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
                            initialValue:
                                "Tổng tiền: " + order.total_price.toString(),
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
                            initialValue: "Tổng số lượng: " +
                                order.total_quantity.toString(),
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
                            initialValue:
                                "Trạng thái: " + order.status.toString(),
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
                            initialValue: "Mã đơn mua: " + order.order_code!,
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
                            initialValue: "Ngày tạo: " + order.created_date!,
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
              SizedBox(
                width: 30,
              ),
              Column(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 450,
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
                                "ID thuốc: " + order.inventory!.id.toString(),
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
                            initialValue:
                                "Tên thuốc: " + order.inventory!.name!,
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
                            initialValue: "Giá thuốc: " +
                                order.inventory!.price.toString(),
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
                            initialValue: "Số lượng thuốc: " +
                                order.inventory!.quantity.toString(),
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
                            initialValue:
                                "Mã hàng: " + order.inventory!.inventory_code!,
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
                            initialValue:
                                "Nơi sản xuất: " + order.inventory!.producer!,
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
              SizedBox(
                width: 30,
              ),
              Column(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 450,
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
                                "Tên chi nhánh: " + order.branch!.name!,
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
                            initialValue:
                                "Mã chi nhánh: " + order.branch!.branch_code!,
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
                            initialValue:
                                "Tên nhân viên: " + order.employee!.name!,
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
                            initialValue:
                                "Tên khách hàng: " + order.customer!.name!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if ((auth.employee['role'] == 'employee' ||
                                auth.employee['role'] == 'store_owner') &&
                            order.status == 'pending')
                          Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 25, top: 10),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    child: Text('Xác nhận đơn mua',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      orderService
                                          .completeOrder(
                                              auth.employee['access_token'],
                                              order.id.toString(),
                                              auth.employee['role'])
                                          .then((value) => {
                                                Navigator.pushReplacementNamed(
                                                    context, '/transaction_out')
                                              });
                                    },
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: Text('Từ chối đơn mua',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      orderService
                                          .rejectOrder(
                                              auth.employee['access_token'],
                                              order.id.toString(),
                                              auth.employee['role'])
                                          .then((value) => {
                                                Navigator.pushReplacementNamed(
                                                    context, '/transaction_out')
                                              });
                                    },
                                  )
                                ],
                              )),
                        if (auth.employee['role'] == 'customer' &&
                            order.status == 'pending')
                          Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 25, top: 10),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: Text('Hủy đơn hàng',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      orderService
                                          .customerRejectOrder(
                                              auth.employee['access_token'],
                                              order.id.toString(),
                                              auth.employee['role'])
                                          .then((value) => {
                                                Navigator.pushReplacementNamed(
                                                    context, '/transaction_out')
                                              });
                                    },
                                  )
                                ],
                              )),
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
