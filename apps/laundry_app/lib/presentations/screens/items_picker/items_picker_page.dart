import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/item_model.dart';

import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/providers/items_provider.dart';
import 'package:laundry_app/providers/orders_provider.dart';
import 'package:laundry_app/utils/routes.dart';

class ItemsPickerPage extends ConsumerStatefulWidget {
  const ItemsPickerPage({super.key});

  @override
  ConsumerState<ItemsPickerPage> createState() => _ItemsPickerPageState();
}

class _ItemsPickerPageState extends ConsumerState<ItemsPickerPage> {
  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsProvider);
    final ordersState = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Selezione capi"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary
              ),
              onPressed: (){
                Navigator.of(context).pushNamed(Routes.addOrder);
              },
              child: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          )
        ],
      ),
      body: LaundryScaffoldPadding(
        child: FutureBuilder(
            future: itemsState.currItems,
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return LaundryLoader();
              }

              final List<ItemModel> items = snapshot.data!;
              final selectedItems = ordersState.selectedItems;

              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 0.65,
                children: List.generate(items.length, (index) {
                  return _buildClothingGridItem(index, items[index], selectedItems, ref);
                }),
              );
            }
        ),
      )
    );
  }

  Widget _buildClothingGridItem(int index, ItemModel item, Map<int, int> selectedItems, WidgetRef ref) {
    final row = index ~/ 2;
    final col = index % 2;
    final quantity = selectedItems[item.id] ?? 0;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: _gridElementBorderRadius(row, col, 3, 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Icon(Icons.checkroom, size: 40, color: Colors.grey[800]),
          Text(
            item.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "quantita selezionata: $quantity",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 2,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => ref.read(ordersProvider.notifier).addItem(item.id),
                  child: const Text("AGGIUNGI"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: quantity > 0
                      ? () => ref.read(ordersProvider.notifier).removeItem(item.id)
                      : null,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius _gridElementBorderRadius(int row, int col, int totalRows, int totalCols) {
    final outsideCorner = const Radius.circular(10.0);
    final innersideCorner = const Radius.circular(4.0);

    final isTopEdge = row == 0;
    final isBottomEdge = row == totalRows - 1;
    final isLeftEdge = col == 0;
    final isRightEdge = col == totalCols - 1;

    return BorderRadius.only(
      topLeft: (isTopEdge && isLeftEdge) ? outsideCorner : innersideCorner,
      topRight: (isTopEdge && isRightEdge) ? outsideCorner : innersideCorner,
      bottomLeft: (isBottomEdge && isLeftEdge) ? outsideCorner : innersideCorner,
      bottomRight: (isBottomEdge && isRightEdge) ? outsideCorner : innersideCorner,
    );
  }
}
