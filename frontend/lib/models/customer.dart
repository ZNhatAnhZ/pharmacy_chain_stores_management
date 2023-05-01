class Customer {
  int? id;
  String? name;
  String? email;
  String? password;
  String? address;
  String? contact;
  Customer({
    this.id,
    this.name,
    this.email,
    this.password,
    this.address,
    this.contact,
  });
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? -1,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      address: json['address'] ?? "",
      contact: json['contact'] ?? "",
    );
  }
}
