import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_assets/models/order_model.dart';

class OrdersRepository {
  final SupabaseClient _client;

  OrdersRepository(this._client);

  Future<List<OrderModel>> getAll() async {
    final data = await _client.from('orders').select('*, clients(*), order_items(*, items(*))').neq('status', OrderStatus.deleted.name);

    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  Future<OrderModel?> getById(int id) async {
    final data = await _client.from('orders').select('*, clients(*), order_items(*, items(*))').eq('id', id).maybeSingle();
    if (data == null) return null;
    return OrderModel.fromJson(data);
  }

  // over here data are removed to let the db auto set the data
  Future<OrderModel> create(OrderModel order) async {
    final orderJson = order.toJson();
    orderJson.remove('id');
    orderJson.remove('created_at');
    final data = await _client
        .from('orders')
        .insert(orderJson)
        .select('*, clients(*), order_items(*, items(*))')
        .single();
    return OrderModel.fromJson(data);
  }

  Future<OrderModel> update(OrderModel order) async {
    final data = await _client
        .from('orders')
        .update(order.toJson())
        .eq('id', order.id as Object)
        .select('*, clients(*), order_items(*, items(*))')
        .single();
    return OrderModel.fromJson(data);
  }
}
