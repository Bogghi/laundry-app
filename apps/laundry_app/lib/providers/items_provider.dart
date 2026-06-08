import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/item_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

class ItemsState {
  final Future<List<ItemModel>>? currItems;
  final bool isLoading;
  final String? errorMessage;

  ItemsState({
    required this.currItems,
    this.isLoading = false,
    this.errorMessage,
  });

  ItemsState copyWith({
    Future<List<ItemModel>>? currItems,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ItemsState(
      currItems: currItems ?? this.currItems,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
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

  Future<void> createItem(String name, String iconName) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final newItem = ItemModel(
        id: 0,
        laundryId: 1,
        name: name.trim(),
        createdAt: DateTime.now(),
        iconName: iconName,
      );
      await SupabaseService.instance.items.create(newItem);
      state = state.copyWith(
        isLoading: false,
        currItems: SupabaseService.instance.items.getAll(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> deleteItem(ItemModel item) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    Map<String, dynamic> itemData = item.toJson();
    itemData['deleted'] = true;
    ItemModel deletedItem = ItemModel.fromJson(itemData);
    try {
      await SupabaseService.instance.items.update(deletedItem);
      state = state.copyWith(
        isLoading: false,
        currItems: SupabaseService.instance.items.getAll(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }
}

final itemsProvider = NotifierProvider<ItemsProvider, ItemsState>(
  ItemsProvider.new,
);
