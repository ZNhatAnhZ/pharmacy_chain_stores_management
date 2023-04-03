class Ledger {
  String? code;
  String? type;
  int? revenue;
  String? created_date;
  Ledger({
    this.code,
    this.type,
    this.revenue,
    this.created_date,
  });
  factory Ledger.fromJson(Map<String, dynamic> json) {
    return Ledger(
      code: json['code'] ?? "",
      type: json['type'] ?? "",
      revenue: json['revenue'] ?? -1,
      created_date: json['created_date'] ?? "",
    );
  }
}
