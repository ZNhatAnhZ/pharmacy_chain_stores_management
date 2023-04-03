class Branch {
  int? id;
  String? name;
  String? address;
  String? branch_code;
  String? email;
  String? contact;
  Branch(
      {this.id,
      this.name,
      this.address,
      this.branch_code,
      this.email,
      this.contact});
  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? -1,
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      branch_code: json['branch_code'] ?? "",
      email: json['email'] ?? "",
      contact: json['contact'] ?? "",
    );
  }
}
