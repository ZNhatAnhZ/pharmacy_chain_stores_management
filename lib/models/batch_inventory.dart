class BatchInventory {
  int? id;
  String? batch_code;
  String? expired_date;
  BatchInventory(
      {required this.id, required this.batch_code, required this.expired_date});
  factory BatchInventory.fromJson(Map<String, dynamic> json) {
    return BatchInventory(
      id: json['id'] ?? -1,
      batch_code: json['batch_code'] ?? "",
      expired_date: json['expired_date'] ?? "",
    );
  }
}
