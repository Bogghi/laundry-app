import 'package:shared_assets/models/client_model.dart';
import 'package:shared_assets/models/order_item_model.dart';

class OrderModel {
  final int? id;
  final String orderNumber;
  final int? clientId;
  final int? laundryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deliveryDate;
  final ClientModel? client;
  final List<OrderItemModel> orderItems;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.clientId,
    required this.laundryId,
    this.createdAt,
    this.updatedAt,
    this.deliveryDate,
    this.client,
    this.orderItems = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String,
      clientId: json['client_id'] as int?,
      laundryId: json['laundry_id'] as int?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      deliveryDate: json['delivery_date'] != null ? DateTime.parse(json['delivery_date'] as String) : null,
      client: json['clients'] != null
          ? ClientModel.fromJson(json['clients'] as Map<String, dynamic>)
          : null,
      orderItems: (json['order_items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'client_id': clientId,
      'laundry_id': laundryId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'delivery_date': deliveryDate?.toIso8601String(),
    };
  }
}
