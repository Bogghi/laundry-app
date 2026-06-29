import 'package:flutter_test/flutter_test.dart';

import 'package:shared_assets/models/order_model.dart';
import 'package:shared_assets/models/client_model.dart';

import 'package:laundry_app/presentations/screens/home/widgets/order_sort.dart';
import 'package:laundry_app/utils/order_sorter.dart';

OrderModel _order({
  String number = '#1',
  DateTime? createdAt,
  DateTime? deliveryDate,
  String? clientName,
}) {
  return OrderModel(
    orderNumber: number,
    clientId: null,
    laundryId: 1,
    createdAt: createdAt,
    deliveryDate: deliveryDate,
    client: clientName == null
        ? null
        : ClientModel(name: clientName, phoneNumber: 0),
  );
}

List<String> _numbers(List<OrderModel> orders) =>
    orders.map((o) => o.orderNumber).toList();

void main() {
  group('sortOrders', () {
    test('order number sorts numerically, not lexically', () {
      final orders = [
        _order(number: '#10'),
        _order(number: '#2'),
        _order(number: '#1'),
      ];
      final result = sortOrders(
        orders,
        const OrderSort(SortKey.orderNumber, true),
      );
      expect(_numbers(result), ['#1', '#2', '#10']);
    });

    test('descending order number reverses the numeric order', () {
      final orders = [
        _order(number: '#2'),
        _order(number: '#10'),
        _order(number: '#1'),
      ];
      final result = sortOrders(
        orders,
        const OrderSort(SortKey.orderNumber, false),
      );
      expect(_numbers(result), ['#10', '#2', '#1']);
    });

    test('delivery date nulls sort last in ascending', () {
      final orders = [
        _order(number: '#noDate'),
        _order(number: '#late', deliveryDate: DateTime(2026, 7, 10)),
        _order(number: '#soon', deliveryDate: DateTime(2026, 7, 1)),
      ];
      final result = sortOrders(
        orders,
        const OrderSort(SortKey.deliveryDate, true),
      );
      expect(_numbers(result), ['#soon', '#late', '#noDate']);
    });

    test('delivery date nulls still sort last in descending', () {
      final orders = [
        _order(number: '#noDate'),
        _order(number: '#late', deliveryDate: DateTime(2026, 7, 10)),
        _order(number: '#soon', deliveryDate: DateTime(2026, 7, 1)),
      ];
      final result = sortOrders(
        orders,
        const OrderSort(SortKey.deliveryDate, false),
      );
      expect(_numbers(result), ['#late', '#soon', '#noDate']);
    });

    test('client name sorts case-insensitively', () {
      final orders = [
        _order(number: '#b', clientName: 'bravo'),
        _order(number: '#A', clientName: 'Alpha'),
        _order(number: '#c', clientName: 'Charlie'),
      ];
      final result = sortOrders(
        orders,
        const OrderSort(SortKey.clientName, true),
      );
      expect(_numbers(result), ['#A', '#b', '#c']);
    });

    test('createdAt default sort (descending) puts newest first', () {
      final orders = [
        _order(number: '#old', createdAt: DateTime(2026, 1, 1)),
        _order(number: '#new', createdAt: DateTime(2026, 6, 1)),
        _order(number: '#mid', createdAt: DateTime(2026, 3, 1)),
      ];
      final result = sortOrders(orders, OrderSort.defaultSort);
      expect(_numbers(result), ['#new', '#mid', '#old']);
    });

    test('does not mutate the input list', () {
      final orders = [_order(number: '#2'), _order(number: '#1')];
      sortOrders(orders, const OrderSort(SortKey.orderNumber, true));
      expect(_numbers(orders), ['#2', '#1']);
    });
  });
}
