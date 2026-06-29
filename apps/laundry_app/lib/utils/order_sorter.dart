import 'package:shared_assets/models/order_model.dart';

import 'package:laundry_app/presentations/screens/home/widgets/order_sort.dart';

/// Returns a new list of [orders] sorted per [sort].
///
/// Pure (does not mutate [orders]) so the home page can safely sort the list it
/// captured from the FutureBuilder. Null dates always sort last, regardless of
/// direction. Order numbers sort numerically (so `#2` precedes `#10`), falling
/// back to a case-insensitive string compare when they don't parse.
List<OrderModel> sortOrders(List<OrderModel> orders, OrderSort sort) {
  final sorted = List<OrderModel>.of(orders);
  final dir = sort.ascending ? 1 : -1;

  sorted.sort((a, b) {
    switch (sort.key) {
      case SortKey.createdAt:
        return _compareDates(a.createdAt, b.createdAt, dir);
      case SortKey.deliveryDate:
        return _compareDates(a.deliveryDate, b.deliveryDate, dir);
      case SortKey.orderNumber:
        return _compareOrderNumbers(a.orderNumber, b.orderNumber) * dir;
      case SortKey.clientName:
        final an = (a.client?.name ?? '').toLowerCase();
        final bn = (b.client?.name ?? '').toLowerCase();
        return an.compareTo(bn) * dir;
    }
  });

  return sorted;
}

/// Compares two nullable dates keeping nulls last in *both* directions. The
/// direction multiplier is applied only to the non-null comparison, so a
/// date-less order never gets promoted to the top when sorting descending.
int _compareDates(DateTime? a, DateTime? b, int dir) {
  if (a == null && b == null) return 0;
  if (a == null) return 1; // a after b
  if (b == null) return -1; // a before b
  return a.compareTo(b) * dir;
}

int _compareOrderNumbers(String a, String b) {
  final na = _numericPart(a);
  final nb = _numericPart(b);
  if (na != null && nb != null) return na.compareTo(nb);
  return a.toLowerCase().compareTo(b.toLowerCase());
}

int? _numericPart(String s) {
  final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
  return digits.isEmpty ? null : int.tryParse(digits);
}
