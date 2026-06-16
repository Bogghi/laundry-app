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
    // Build a fresh state directly: copyWith uses `?? this.x`, so it cannot
    // clear a nullable field back to null.
    state = OrdersState(
      currOrders: state.currOrders,
      selectedItems: state.selectedItems,
      orderClient: client,
      deliveryDate: state.deliveryDate,
      orderNumber: state.orderNumber,
    );
  }

  void setDeliveryDate(DateTime? date) {
    // Build a fresh state directly so a null date actually clears the field.
    state = OrdersState(
      currOrders: state.currOrders,
      selectedItems: state.selectedItems,
      orderClient: state.orderClient,
      deliveryDate: date,
      orderNumber: state.orderNumber,
    );
  }

  void loadOrder(OrderModel order) {
    final Map<int, int> selectedItems = {
      for (final orderItem in order.orderItems)
        if (orderItem.itemId != null) orderItem.itemId!: orderItem.quantity ?? 0,
    };

    state = OrdersState(
      currOrders: state.currOrders,
      selectedItems: selectedItems,
      orderClient: order.client,
      deliveryDate: order.deliveryDate,
      orderNumber: order.orderNumber,
    );
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

  Future<OrderModel> updateOrder(OrderModel original) async {
    final OrderModel updated = OrderModel(
      id: original.id,
      orderNumber: state.orderNumber,
      clientId: state.orderClient?.id,
      laundryId: original.laundryId,
      deliveryDate: state.deliveryDate,
      status: original.status,
    );
    final OrderModel saved = await SupabaseService.instance.orders.update(updated);

    state = state.copyWith(
      currOrders: SupabaseService.instance.orders.getAll(),
    );
    return saved;
  }

  void clearNewOrder() {
    // Build a fresh state directly so the nullable client/date are truly cleared.
    state = OrdersState(
      currOrders: state.currOrders,
      selectedItems: const {},
      orderClient: null,
      deliveryDate: null,
      orderNumber: '',
    );
  }
}

final ordersProvider = NotifierProvider<OrdersProvider, OrdersState>(OrdersProvider.new);

