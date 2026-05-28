import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_assets/models/item_model.dart';

class ItemsRepository {
  final SupabaseClient _client;

  ItemsRepository(this._client);

  Future<List<ItemModel>> getAll() async {
    final data = await _client.from('items').select().eq('deleted', false);
    return data.map((json) => ItemModel.fromJson(json)).toList();
  }

  Future<ItemModel?> getById(int id) async {
    final data = await _client.from('items').select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return ItemModel.fromJson(data);
  }

  Future<ItemModel> create(ItemModel item) async {
    final data = await _client
        .from('items')
        .insert(item.toJson())
        .select()
        .single();
    return ItemModel.fromJson(data);
  }

  Future<ItemModel> update(ItemModel item) async {
    final data = await _client
        .from('items')
        .update(item.toJson())
        .eq('id', item.id)
        .select()
        .single();
    return ItemModel.fromJson(data);
  }
}
