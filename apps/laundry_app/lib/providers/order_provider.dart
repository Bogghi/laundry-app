import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/order_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

class OrderState {
  final Future<List<OrderModel>>? currOrders;

  OrderState({
    required this.currOrders,
  });

  OrderState copyWith({
   Future <List<OrderModel>>? currOrders,
  }) {
    return OrderState(
      currOrders: currOrders ?? this.currOrders,
    );
  }
}

class OrderProvider extends Notifier<OrderState> {
  @override
  OrderState build() {
    final futureOrders = SupabaseService.instance.orders.getAll();
    return OrderState(currOrders: futureOrders);
  }

  void fetchOrders() {
    state = state.copyWith(currOrders: SupabaseService.instance.orders.getAll());
  }
}

final orderProvider = NotifierProvider<OrderProvider, OrderState>(OrderProvider.new);

