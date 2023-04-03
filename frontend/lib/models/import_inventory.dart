import 'package:medical_chain_manangement/models/batch_inventory.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/models/employee.dart';
import 'package:medical_chain_manangement/models/inventory.dart';
import 'package:medical_chain_manangement/models/supplier.dart';

class ImportInventory {
  int? id;
  int? price;
  int? quantity;
  String? status;
  String? import_inventory_code;
  int? batch_inventory_id;
  int? inventory_id;
  int? supplier_id;
  int? branch_id;
  Inventory? inventory;
  Supplier? supplier;
  BatchInventory? batch_inventory;
  Branch? branch;
  Employee? employee;
  String? created_date;
  ImportInventory({
    this.id,
    this.price,
    this.quantity,
    this.status,
    this.import_inventory_code,
    this.batch_inventory_id,
    this.inventory_id,
    this.supplier_id,
    this.branch_id,
    this.inventory,
    this.supplier,
    this.batch_inventory,
    this.branch,
    this.employee,
    this.created_date,
  });
  factory ImportInventory.fromJson(Map<String, dynamic> json) {
    return ImportInventory(
      id: json['id'] ?? -1,
      price: json['price'] ?? -1,
      quantity: json['quantity'] ?? -1,
      status: json['status'] ?? '',
      import_inventory_code: json['import_inventory_code'] ?? "",
      batch_inventory_id: json['batch_inventory_id'] ?? -1,
      inventory_id: json['inventory_id'] ?? -1,
      supplier_id: json['supplier_id'] ?? -1,
      branch_id: json['branch_id'] ?? -1,
      inventory: Inventory.fromJson(json['inventory'] ?? Map()),
      supplier: Supplier.fromJson(json['supplier'] ?? Map()),
      batch_inventory:
          BatchInventory.fromJson(json['batch_inventory'] ?? Map()),
      branch: Branch.fromJson(json['branch'] ?? Map()),
      employee: Employee.fromJson(json['employee'] ?? Map()),
      created_date: json['created_date'] ?? "",
    );
  }
}
