import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/order_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

class OrdersState {
  final Future<List<OrderModel>>? currOrders;
  final Map<int, int> selectedItems;

  OrdersState({
    required this.currOrders,
    this.selectedItems = const {},
  });

  OrdersState copyWith({
   Future <List<OrderModel>>? currOrders,
   Map<int, int>? selectedItems,
  }) {
    return OrdersState(
      currOrders: currOrders ?? this.currOrders,
      selectedItems: selectedItems ?? this.selectedItems,
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

  void addItem(int itemId) {
    final updated = Map<int, int>.from(state.selectedItems);
    updated[itemId] = (updated[itemId] ?? 0) + 1;
    state = state.copyWith(selectedItems: updated);
  }

  void removeItem(int itemId) {
    final updated = Map<int, int>.from(state.selectedItems);
    final current = updated[itemId] ?? 0;
    if (current <= 1) {
      updated.remove(itemId);
    } else {
      updated[itemId] = current - 1;
    }
    state = state.copyWith(selectedItems: updated);
  }
}

final ordersProvider = NotifierProvider<OrdersProvider, OrdersState>(OrdersProvider.new);

