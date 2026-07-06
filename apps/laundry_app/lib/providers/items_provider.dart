import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/item_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

import 'package:laundry_app/providers/auth_provider.dart';

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
  int get _laundryId {
    final laundryId = ref.read(authProvider)?.userLaundry?.laundryId;
    if (laundryId == null) {
      throw StateError('Cannot access items without a current laundry');
    }
    return laundryId;
  }

  @override
  ItemsState build() {
    final laundryId = ref.watch(authProvider)?.userLaundry?.laundryId;
    final futureItems = laundryId == null
        ? Future.value(<ItemModel>[])
        : SupabaseService.instance.items.getAll(laundryId);
    return ItemsState(currItems: futureItems);
  }

  void fetchItems() {
    state = state.copyWith(currItems: SupabaseService.instance.items.getAll(_laundryId));
  }

  Future<void> createItem(String name, String iconName) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final newItem = ItemModel(
        id: 0,
        laundryId: _laundryId,
        name: name.trim(),
        createdAt: DateTime.now(),
        iconName: iconName,
      );
      await SupabaseService.instance.items.create(newItem);
      state = state.copyWith(
        isLoading: false,
        currItems: SupabaseService.instance.items.getAll(_laundryId),
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
        currItems: SupabaseService.instance.items.getAll(_laundryId),
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
