class HeaderStatistic {
  int? order_month_count;
  int? order_month_price;
  int? order_percent_from_last_month;
  int? import_inventories_month_count;
  int? import_inventories_month_price;
  int? im_percent_from_last_month;
  HeaderStatistic(
      {this.order_month_count,
      this.order_month_price,
      this.order_percent_from_last_month,
      this.import_inventories_month_count,
      this.import_inventories_month_price,
      this.im_percent_from_last_month,
      });
  factory HeaderStatistic.fromJson(Map<String, dynamic> json) {
    return HeaderStatistic(
      order_month_count: json['order_month_count'] ?? -1,
      order_month_price: json['order_month_price'] ?? -1,
      order_percent_from_last_month: json['order_percent_from_last_month'] ?? -1,
      import_inventories_month_count: json['import_inventories_month_count'] ?? -1,
      import_inventories_month_price: json['import_inventories_month_price'] ?? -1,
      im_percent_from_last_month: json['im_percent_from_last_month'] ?? -1,
    );
  }
}
