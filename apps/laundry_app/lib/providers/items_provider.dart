import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/item_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

class ItemsState {
  final Future<List<ItemModel>>? currItems;

  ItemsState({
    required this.currItems,
  });

  ItemsState copyWith({
    Future<List<ItemModel>>? currItems,
  }) {
    return ItemsState(
      currItems: currItems ?? this.currItems,
    );
  }
}

class ItemsProvider extends Notifier<ItemsState> {
  @override
  ItemsState build() {
    final futureItems = SupabaseService.instance.items.getAll();
    return ItemsState(currItems: futureItems);
  }

  void fetchItems() {
    state = state.copyWith(currItems: SupabaseService.instance.items.getAll());
  }
}

final itemsProvider = NotifierProvider<ItemsProvider, ItemsState>(ItemsProvider.new);
