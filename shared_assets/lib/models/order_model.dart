class OrderModel {
  final int id;
  final String orderNumber;
  final int clientId;
  final DateTime? date;
  final String status;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.clientId,
    this.date,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String,
      clientId: json['client_id'] as int,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'client_id': clientId,
      'date': date?.toIso8601String(),
      'status': status,
    };
  }
}
