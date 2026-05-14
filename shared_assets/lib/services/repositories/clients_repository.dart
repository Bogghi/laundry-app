import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_assets/models/client_model.dart';

class ClientsRepository {
  final SupabaseClient _client;

  ClientsRepository(this._client);

  Future<List<ClientModel>> getAll() async {
    final data = await _client.from('clients').select();
    return data.map((json) => ClientModel.fromJson(json)).toList();
  }

  Future<ClientModel?> getById(int id) async {
    final data = await _client.from('clients').select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return ClientModel.fromJson(data);
  }

  Future<ClientModel> create(ClientModel user) async {
    final data = await _client
        .from('clients')
        .insert(user.toJson())
        .select()
        .single();
    return ClientModel.fromJson(data);
  }

  Future<ClientModel> update(ClientModel user) async {
    final data = await _client
        .from('clients')
        .update(user.toJson())
        .eq('id', user.id)
        .select()
        .single();
    return ClientModel.fromJson(data);
  }

  Future<void> delete(int id) async {
    await _client.from('clients').delete().eq('id', id);
  }
}
