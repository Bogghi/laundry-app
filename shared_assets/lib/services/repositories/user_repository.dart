import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_assets/models/user_model.dart';

class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  Future<List<UserModel>> getAll() async {
    final data = await _client.from('clients').select();
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel?> getById(int id) async {
    final data = await _client.from('clients').select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  Future<UserModel> create(UserModel user) async {
    final data = await _client
        .from('clients')
        .insert(user.toJson())
        .select()
        .single();
    return UserModel.fromJson(data);
  }

  Future<UserModel> update(UserModel user) async {
    final data = await _client
        .from('clients')
        .update(user.toJson())
        .eq('id', user.id)
        .select()
        .single();
    return UserModel.fromJson(data);
  }

  Future<void> delete(int id) async {
    await _client.from('clients').delete().eq('id', id);
  }
}
