import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_assets/models/laundry_model.dart';

class LaundriesRepository {
  final SupabaseClient _client;

  LaundriesRepository(this._client);

  Future<LaundryModel?> findByNameCaseInsensitive(String name) async {
    final data = await _client.from('laundries').select().ilike('name', name).maybeSingle();
    if (data == null) return null;
    return LaundryModel.fromJson(data);
  }

  Future<LaundryModel> create(LaundryModel laundry) async {
    final laundryJson = laundry.toJson();
    laundryJson.remove('id');
    laundryJson.remove('created_at');
    laundryJson.remove('updated_at');
    final data = await _client.from('laundries').insert(laundryJson).select().single();
    return LaundryModel.fromJson(data);
  }
}
