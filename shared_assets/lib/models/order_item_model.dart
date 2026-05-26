import 'package:shared_assets/models/item_model.dart';

class OrderItemModel {
  final int? id;
  final int? orderId;
  final int? itemId;
  final int? quantity;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ItemModel? item;

  OrderItemModel({
    this.id,
    this.orderId,
    this.itemId,
    this.quantity,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.item,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int?,
      orderId: json['order_id'] as int?,
      itemId: json['item_id'] as int?,
      quantity: json['quantity'] as int?,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      item: json['items'] != null ? ItemModel.fromJson(json['items'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'item_id': itemId,
      'quantity': quantity,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
