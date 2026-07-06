import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_assets/models/user_laundry_model.dart';
import 'package:shared_assets/models/user_model.dart';

class EmployeeRequestModel {
  final UserLaundryModel userLaundry;
  final UserModel user;

  EmployeeRequestModel({required this.userLaundry, required this.user});
}

class UserLaundriesRepository {
  final SupabaseClient _client;

  UserLaundriesRepository(this._client);

  Future<UserLaundryModel> create({
    required int userId,
    required int laundryId,
    required UserLaundryStatus status,
  }) async {
    final userLaundry = UserLaundryModel(
      userId: userId,
      laundryId: laundryId,
      status: status,
    );
    final userLaundryJson = userLaundry.toJson();
    userLaundryJson.remove('id');
    userLaundryJson.remove('created_at');
    userLaundryJson.remove('updated_at');
    final data = await _client.from('user_laundries').insert(userLaundryJson).select().single();
    return UserLaundryModel.fromJson(data);
  }

  Future<UserLaundryModel?> findForUser(int userId) async {
    final data = await _client.from('user_laundries').select().eq('user_id', userId).maybeSingle();
    if (data == null) return null;
    return UserLaundryModel.fromJson(data);
  }

  Future<List<EmployeeRequestModel>> findForLaundry(int laundryId) async {
    final data = await _client
        .from('user_laundries')
        .select('*, users(*)')
        .eq('laundry_id', laundryId);
    return data.map((row) {
      final userJson = row['users'] as Map<String, dynamic>;
      return EmployeeRequestModel(
        userLaundry: UserLaundryModel.fromJson(row),
        user: UserModel.fromJson(userJson),
      );
    }).toList();
  }

  Future<UserLaundryModel> updateStatus({
    required int id,
    required UserLaundryStatus status,
  }) async {
    final data = await _client
        .from('user_laundries')
        .update({'status': status.name})
        .eq('id', id)
        .select()
        .single();
    return UserLaundryModel.fromJson(data);
  }

  Future<void> delete(int id) async {
    await _client.from('user_laundries').delete().eq('id', id);
  }
}
