import 'package:supabase_flutter/supabase_flutter.dart';

import 'repositories/order_repository.dart';
import 'repositories/user_repository.dart';

class SupabaseService {
  final SupabaseClient _client;

  late final OrderRepository orders;
  late final UserRepository users;

  SupabaseService._(this._client) {
    orders = OrderRepository(_client);
    users = UserRepository(_client);
  }

  static SupabaseService? _instance;

  static SupabaseService get instance {
    if (_instance == null) {
      throw Exception('SupabaseService not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  static Future<SupabaseService> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
    _instance = SupabaseService._(Supabase.instance.client);
    return _instance!;
  }

  static void reset() {
    _instance = null;
  }
}
