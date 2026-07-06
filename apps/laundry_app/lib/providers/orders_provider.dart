import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/order_model.dart';
import 'package:shared_assets/models/order_item_model.dart';
import 'package:shared_assets/models/client_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

import 'package:laundry_app/providers/auth_provider.dart';

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
  int get _laundryId {
    final laundryId = ref.read(authProvider)?.userLaundry?.laundryId;
    if (laundryId == null) {
      throw StateError('Cannot access orders without a current laundry');
    }
    return laundryId;
  }

  @override
  OrdersState build() {
    final laundryId = ref.watch(authProvider)?.userLaundry?.laundryId;
    final futureOrders = laundryId == null
        ? Future.value(<OrderModel>[])
        : SupabaseService.instance.orders.getAll(laundryId);
    return OrdersState(currOrders: futureOrders);
  }

  void fetchOrders() {
    state = state.copyWith(currOrders: SupabaseService.instance.orders.getAll(_laundryId));
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
        laundryId: _laundryId,
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
        currOrders: SupabaseService.instance.orders.getAll(_laundryId)
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

    await _syncOrderItems(original);

    state = state.copyWith(
      currOrders: SupabaseService.instance.orders.getAll(_laundryId),
    );
    return saved;
  }

  // Reconcile the persisted order_items against the edited selection: delete
  // rows no longer selected, update changed quantities, insert new items.
  Future<void> _syncOrderItems(OrderModel original) async {
    final Map<int, OrderItemModel> existingByItemId = {
      for (final orderItem in original.orderItems)
        if (orderItem.itemId != null) orderItem.itemId!: orderItem,
    };
    final Map<int, int> selected = state.selectedItems;

    final List<Future<void>> operations = [];

    // Delete items that were removed from the selection.
    for (final entry in existingByItemId.entries) {
      if (!selected.containsKey(entry.key) && entry.value.id != null) {
        operations.add(
          SupabaseService.instance.orderItems.delete(entry.value.id!),
        );
      }
    }

    // Insert new items or update quantities of existing ones.
    for (final entry in selected.entries) {
      final existing = existingByItemId[entry.key];
      if (existing == null) {
        operations.add(
          SupabaseService.instance.orderItems.create(OrderItemModel(
            orderId: original.id,
            itemId: entry.key,
            quantity: entry.value,
          )),
        );
      } else if (existing.quantity != entry.value && existing.id != null) {
        operations.add(
          SupabaseService.instance.orderItems.update(OrderItemModel(
            id: existing.id,
            orderId: original.id,
            itemId: entry.key,
            quantity: entry.value,
          )),
        );
      }
    }

    await Future.wait(operations);
  }

  // Soft-delete: flip the order's status to `deleted` and persist it. The
  // repository's getAll() filters out `deleted` rows, so the order drops out of
  // the list on the next fetch. Mirrors ClientsProvider.deleteClient.
  Future<void> deleteOrder(OrderModel order) async {
    final OrderModel deletedOrder = OrderModel(
      id: order.id,
      orderNumber: order.orderNumber,
      clientId: order.clientId,
      laundryId: order.laundryId,
      deliveryDate: order.deliveryDate,
      status: OrderStatus.deleted,
    );
    await SupabaseService.instance.orders.update(deletedOrder);
    fetchOrders();
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

