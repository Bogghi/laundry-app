import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/user_model.dart';

class OrderState {
  final String? orderNumber;
  final UserModel? newOrderClient;

  OrderState({
    this.orderNumber,
    this.newOrderClient,
  });

  OrderState copyWith({
    String? orderNumber,
    UserModel? newOrderClient,
  }) => OrderState(
    orderNumber: orderNumber ?? this.orderNumber,
    newOrderClient: newOrderClient ?? this.newOrderClient,
  );
}

class OrderProvider extends Notifier<OrderState> {
  @override
  OrderState build() {
    return OrderState();
  }

  void setNewOrderData(
    String? orderNumber,
    UserModel? newOrderClient,
  ) {
    state = state.copyWith(
      orderNumber: orderNumber,
      newOrderClient: newOrderClient,
    );
  }
}

final orderProvider = NotifierProvider<OrderProvider, OrderState>(OrderProvider.new);

