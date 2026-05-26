import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/order_model.dart';
import 'package:shared_assets/models/order_item_model.dart';
import 'package:shared_assets/models/client_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

class OrdersState {
  final Future<List<OrderModel>>? currOrders;
  final Map<int, int> selectedItems;
  final ClientModel? orderClient;
  final DateTime? deliveryDate;
  final String orderNumber;

  OrdersState({
    required this.currOrders,
    this.selectedItems = const {},
    this.orderClient,
    this.deliveryDate,
    this.orderNumber = '',
  });

  OrdersState copyWith({
   Future <List<OrderModel>>? currOrders,
   Map<int, int>? selectedItems,
   ClientModel? orderClient,
   DateTime? deliveryDate,
   String? orderNumber,
  }) {
    return OrdersState(
      currOrders: currOrders ?? this.currOrders,
      selectedItems: selectedItems ?? this.selectedItems,
      orderClient: orderClient ?? this.orderClient,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      orderNumber: orderNumber ?? this.orderNumber,
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

  void setOrderClient(ClientModel? client) {
    state = state.copyWith(orderClient: client);
  }

  void setDeliveryDate(DateTime? date) {
    state = state.copyWith(deliveryDate: date);
  }

  void setOrderNumber(String number) {
    state = state.copyWith(orderNumber: number);
  }

  // here clearNewOrder is not called because it will be called by the items_picker page pop
  Future<OrderModel> saveOrder() async {
    try {
      final OrderModel newOrder = OrderModel(
        orderNumber: state.orderNumber,
        clientId: state.orderClient!.id,
        laundryId: 1,
        deliveryDate: state.deliveryDate,
      );
      final OrderModel savedOrder = await SupabaseService.instance.orders.create(newOrder);

      await Future.wait(state.selectedItems.entries.map((entry) {
        return SupabaseService.instance.orderItems.create(OrderItemModel(
          orderId: savedOrder.id,
          itemId: entry.key,
          quantity: entry.value,
        ));
      }));

      state = state.copyWith(
        currOrders: SupabaseService.instance.orders.getAll()
      );
      return savedOrder;
    }
    catch (e) {
      rethrow;
    }
  }

  void clearNewOrder() {
    state = state.copyWith(
      selectedItems: {},
      orderClient: null,
      deliveryDate: null,
      orderNumber: '',
    );
  }
}

final ordersProvider = NotifierProvider<OrdersProvider, OrdersState>(OrdersProvider.new);

