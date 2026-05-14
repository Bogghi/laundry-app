import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/order_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

class OrdersState {
  final Future<List<OrderModel>>? currOrders;

  OrdersState({
    required this.currOrders,
  });

  OrdersState copyWith({
   Future <List<OrderModel>>? currOrders,
  }) {
    return OrdersState(
      currOrders: currOrders ?? this.currOrders,
    );
  }
}

class OrdersProvider extends Notifier<OrdersState> {
  @override
  OrdersState build() {
    final futureOrders = SupabaseService.instance.orders.getAll();
    return OrdersState(currOrders: futureOrders);
  }

  void fetchOrders() {
    state = state.copyWith(currOrders: SupabaseService.instance.orders.getAll());
  }
}

final ordersProvider = NotifierProvider<OrdersProvider, OrdersState>(OrdersProvider.new);

