import 'dart:developer';

import 'package:medical_chain_manangement/models/category.dart';
import 'package:medical_chain_manangement/models/branch.dart';
import 'package:medical_chain_manangement/models/batch_inventory.dart';
import 'package:medical_chain_manangement/models/supplier.dart';

class Inventory {
  int? id;
  String? name;
  int? price;
  String? inventory_type;
  int? quantity;
  String? inventory_code;
  String? main_ingredient;
  String? producer;
  Branch? branch;
  Category? category;
  BatchInventory? batch_inventory;
  Supplier? supplier;
  String? image;
  int? total_order_quantity;
  String? created_date;
  Inventory({
    this.id,
    this.name,
    this.price,
    this.inventory_type,
    this.quantity,
    this.inventory_code,
    this.main_ingredient,
    this.producer,
    this.branch,
    this.category,
    this.batch_inventory,
    this.supplier,
    this.image,
    this.total_order_quantity,
    this.created_date,
  });
  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'] ?? -1,
      name: json['name'] ?? "",
      price: json['price'] ?? -1,
      inventory_type: json['inventory_type'] ?? "",
      quantity: json['quantity'] ?? -1,
      inventory_code: json['inventory_code'] ?? "",
      main_ingredient: json['main_ingredient'] ?? "",
      producer: json['producer'] ?? "",
      branch: Branch.fromJson(json['branch'] ?? Map()),
      category: Category.fromJson(json['category'] ?? Map()),
      batch_inventory:
          BatchInventory.fromJson(json['batch_inventory'] ?? Map()),
      supplier: Supplier.fromJson(json['supplier'] ?? Map()),
      image: json['image'] ?? "",
      total_order_quantity: json['total_order_quantity'] ?? -1,
      created_date: json['created_date'] ?? "",
    );
  }
}
