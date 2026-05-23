import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_assets/models/order_model.dart';

class OrdersRepository {
  final SupabaseClient _client;

  OrdersRepository(this._client);

  Future<List<OrderModel>> getAll() async {
    final data = await _client.from('orders').select();
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  Future<OrderModel?> getById(int id) async {
    final data = await _client.from('orders').select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return OrderModel.fromJson(data);
  }

  Future<OrderModel> create(OrderModel order) async {
    final orderJson = order.toJson();
    orderJson.remove('id');
    final data = await _client
        .from('orders')
        .insert(orderJson)
        .select()
        .single();
    return OrderModel.fromJson(data);
  }

  Future<OrderModel> update(OrderModel order) async {
    final data = await _client
        .from('orders')
        .update(order.toJson())
        .eq('id', order.id as Object)
        .select()
        .single();
    return OrderModel.fromJson(data);
  }

  Future<void> delete(int id) async {
    await _client.from('orders').delete().eq('id', id);
  }
}
