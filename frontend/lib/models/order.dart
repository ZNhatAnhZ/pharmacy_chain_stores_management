import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:medical_chain_manangement/models/inventory.dart';

class Order {
  int? id;
  int? total_price;
  int? total_quantity;
  String? status;
  String? order_code;
  String? customer_name;
  int? employee_id;
  int? inventory_id;
  int? branch_id;
  Inventory? inventory;
  Branch? branch;
  Employee? employee;
  String? created_date;
  Order({
    this.id,
    this.total_price,
    this.total_quantity,
    this.status,
    this.order_code,
    this.customer_name,
    this.employee_id,
    this.inventory_id,
    this.branch_id,
    this.inventory,
    this.branch,
    this.employee,
    this.created_date,
  });
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? -1,
      total_price: json['total_price'] ?? -1,
      total_quantity: json['total_quantity'] ?? -1,
      status: json['status'] ?? '',
      order_code: json['order_code'] ?? "",
      customer_name: json['customer_name'] ?? "",
      employee_id: json['employee_id'] ?? -1,
      inventory_id: json['inventory_id'] ?? -1,
      branch_id: json['branch_id'] ?? -1,
      inventory: Inventory.fromJson(json['inventory'] ?? Map()),
      branch: Branch.fromJson(json['branch'] ?? Map()),
      employee: Employee.fromJson(json['employee'] ?? Map()),
      created_date: json['created_date'] ?? "",
    );
  }
}
