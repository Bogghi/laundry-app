/// The keys the home-screen order list can be sorted by.
enum SortKey { createdAt, deliveryDate, orderNumber, clientName }

/// An immutable sort selection: which [SortKey] and which direction.
///
/// Owned by the home page as a `ValueNotifier<OrderSort>` and passed into the
/// filter panel, mirroring how the filter text controllers are parent-owned.
/// Selecting a new key resets to that key's natural default direction;
/// re-selecting the active key flips direction.
class OrderSort {
  final SortKey key;
  final bool ascending;

  const OrderSort(this.key, this.ascending);

  /// Newest creation date first — the list's resting order.
  static const OrderSort defaultSort = OrderSort(SortKey.createdAt, false);

  /// Switch to [k] using its natural default direction.
  OrderSort withKey(SortKey k) => OrderSort(k, _defaultAscendingFor(k));

  /// Same key, flipped direction.
  OrderSort toggled() => OrderSort(key, !ascending);

  static bool _defaultAscendingFor(SortKey k) {
    switch (k) {
      case SortKey.createdAt:
        return false; // newest first
      case SortKey.deliveryDate:
        return true; // soonest first
      case SortKey.orderNumber:
        return true; // #1 -> #99
      case SortKey.clientName:
        return true; // A -> Z
    }
  }

  @override
  bool operator ==(Object other) =>
      other is OrderSort && other.key == key && other.ascending == ascending;

  @override
  int get hashCode => Object.hash(key, ascending);
}
