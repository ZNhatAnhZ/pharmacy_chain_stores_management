class Supplier {
  int? id;
  String? name;
  String? contact;
  String? email;
  String? address;
  Supplier(
      {required this.name,
      required this.id,
      required this.contact,
      required this.email,
      required this.address});
  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] ?? -1,
      name: json['name'] ?? "",
      contact: json['contact'] ?? "",
      email: json['email'] ?? "",
      address: json['address'] ?? "",
    );
  }
}
