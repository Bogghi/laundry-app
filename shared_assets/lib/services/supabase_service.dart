import 'package:supabase_flutter/supabase_flutter.dart';

import 'repositories/orders_repository.dart';
import 'repositories/clients_repository.dart';
import 'repositories/items_repository.dart';
import 'repositories/order_items_repository.dart';

class SupabaseService {
  final SupabaseClient _client;

  late final OrdersRepository orders;
  late final ClientsRepository users;
  late final ItemsRepository items;
  late final OrderItemsRepository orderItems;

  SupabaseService._(this._client) {
    orders = OrdersRepository(_client);
    users = ClientsRepository(_client);
    items = ItemsRepository(_client);
    orderItems = OrderItemsRepository(_client);
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
