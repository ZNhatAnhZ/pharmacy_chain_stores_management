class Customer {
  int? id;
  String? name;
  String? email;
  String? password;
  String? address;
  String? contact;
  String? gender;
  Customer({
    this.id,
    this.name,
    this.email,
    this.password,
    this.address,
    this.contact,
    this.gender,
  });
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? -1,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      address: json['address'] ?? "",
      contact: json['contact'] ?? "",
      gender: json['gender'] ?? "",
    );
  }
}
