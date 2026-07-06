import 'package:bcrypt/bcrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_assets/models/user_model.dart';

class UsersRepository {
  final SupabaseClient _client;

  UsersRepository(this._client);

  Future<UserModel?> findByUsername(String username) async {
    final data = await _client.from('users').select().eq('username', username).maybeSingle();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  Future<UserModel?> getById(int id) async {
    final data = await _client.from('users').select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  Future<UserModel> create({
    required String username,
    required String password,
    required UserType type,
  }) async {
    final user = UserModel(
      username: username,
      passwordHash: BCrypt.hashpw(password, BCrypt.gensalt()),
      type: type,
    );
    final userJson = user.toJson();
    userJson.remove('id');
    userJson.remove('created_at');
    userJson.remove('updated_at');
    final data = await _client.from('users').insert(userJson).select().single();
    return UserModel.fromJson(data);
  }

  bool verifyPassword(String plainPassword, String storedHash) {
    return BCrypt.checkpw(plainPassword, storedHash);
  }
}
