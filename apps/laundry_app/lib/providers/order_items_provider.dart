import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/order_item_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

class OrderItemsState {
  final Future<List<OrderItemModel>>? currOrderItems;

  OrderItemsState({
    required this.currOrderItems,
  });

  OrderItemsState copyWith({
    Future<List<OrderItemModel>>? currOrderItems,
  }) {
    return OrderItemsState(
      currOrderItems: currOrderItems ?? this.currOrderItems,
    );
  }
}

class OrderItemsProvider extends Notifier<OrderItemsState> {
  @override
  OrderItemsState build() {
    final futureOrderItems = SupabaseService.instance.orderItems.getAll();
    return OrderItemsState(currOrderItems: futureOrderItems);
  }

  void fetchOrderItems() {
    state = state.copyWith(currOrderItems: SupabaseService.instance.orderItems.getAll());
  }

  void fetchByOrderId(int orderId) {
    state = state.copyWith(
      currOrderItems: SupabaseService.instance.orderItems.getByOrderId(orderId),
    );
  }
}

final orderItemsProvider = NotifierProvider<OrderItemsProvider, OrderItemsState>(OrderItemsProvider.new);
