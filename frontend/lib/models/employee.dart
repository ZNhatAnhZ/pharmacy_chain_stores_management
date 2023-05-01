import 'package:medical_chain_manangement/models/branch.dart';

class Employee {
  int? id;
  String? name;
  String? email;
  String? password;
  String? contact;
  String? gender;
  String? address;
  int? branch_id;
  Branch? branch;
  Employee({
    this.id,
    this.name,
    this.email,
    this.password,
    this.branch_id,
    this.branch,
    this.contact,
    this.gender,
    this.address,
  });
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? -1,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      contact: json['contact'] ?? "",
      gender: json['gender'] ?? "",
      address: json['address'] ?? "",
      branch_id: json['branch_id'] ?? -1,
      branch: Branch.fromJson(json['branch'] ?? Map()),
    );
  }
}

class EmployeeCredential {
  String email;
  String password;
  EmployeeCredential({required this.email, required this.password});
}
