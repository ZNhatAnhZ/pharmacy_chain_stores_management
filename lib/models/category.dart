class Category {
  int? id;
  String? name;
  Category({required this.id, required this.name});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? -1,
      name: json['name'] ?? "",
    );
  }
}
