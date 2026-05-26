import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_assets/models/order_item_model.dart';

class OrderItemsRepository {
  final SupabaseClient _client;

  OrderItemsRepository(this._client);

  Future<List<OrderItemModel>> getAll() async {
    final data = await _client.from('order_items').select('*, items(*)');
    return data.map((json) => OrderItemModel.fromJson(json)).toList();
  }

  Future<List<OrderItemModel>> getByOrderId(int orderId) async {
    final data = await _client
        .from('order_items')
        .select('*, items(*)')
        .eq('order_id', orderId);
    return data.map((json) => OrderItemModel.fromJson(json)).toList();
  }

  Future<OrderItemModel?> getById(int id) async {
    final data = await _client
        .from('order_items')
        .select('*, items(*)')
        .eq('id', id)
        .maybeSingle();
    if (data == null) return null;
    return OrderItemModel.fromJson(data);
  }

  Future<OrderItemModel> create(OrderItemModel orderItem) async {
    final json = orderItem.toJson();
    json.remove('id');
    json.remove('created_at');
    final data = await _client
        .from('order_items')
        .insert(json)
        .select('*, items(*)')
        .single();
    return OrderItemModel.fromJson(data);
  }

  Future<OrderItemModel> update(OrderItemModel orderItem) async {
    final data = await _client
        .from('order_items')
        .update(orderItem.toJson())
        .eq('id', orderItem.id as Object)
        .select('*, items(*)')
        .single();
    return OrderItemModel.fromJson(data);
  }

  Future<void> delete(int id) async {
    await _client.from('order_items').delete().eq('id', id);
  }
}
