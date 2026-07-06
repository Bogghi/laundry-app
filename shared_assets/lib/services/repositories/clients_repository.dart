import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_assets/models/client_model.dart';

class ClientsRepository {
  final SupabaseClient _client;

  ClientsRepository(this._client);

  Future<List<ClientModel>> getAll(int laundryId) async {
    final data = await _client
        .from('clients')
        .select()
        .eq('laundry_id', laundryId)
        .neq('status', ClientStatus.deleted.name);
    return data.map((json) => ClientModel.fromJson(json)).toList();
  }

  Future<ClientModel?> getById(int id) async {
    final data = await _client.from('clients').select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return ClientModel.fromJson(data);
  }

  Future<ClientModel> update(ClientModel user) async {
    if (user.id == null) {
      throw StateError('Cannot update a ClientModel without an id');
    }
    final data = await _client
        .from('clients')
        .update(user.toJson())
        .eq('id', user.id!)
        .select()
        .single();
    return ClientModel.fromJson(data);
  }

  Future<ClientModel> create(ClientModel client) async {
    final clientJson = client.toJson();
    clientJson.remove('id');
    clientJson.remove('created_at');
    clientJson.remove('updated_at');
    final data = await _client
      .from('clients')
      .insert(clientJson)
      .select()
      .single();
    return ClientModel.fromJson(data);
  }
}
