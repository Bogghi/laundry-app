import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/item_model.dart';

import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/presentations/widgets/laundry_grid.dart';
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

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) ref.read(ordersProvider.notifier).clearNewOrder();
      },
      child: Scaffold(
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

              return LaundryGrid(
                itemCount: items.length,
                itemBuilder: (index, borderRadius) {
                  final item = items[index];
                  final quantity = selectedItems[item.id] ?? 0;

                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: borderRadius,
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
                                    ? () =>
                                        ref.read(ordersProvider.notifier).removeItem(item.id)
                                    : null,
                                child: const Icon(Icons.remove),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        )
      ),
    );
  }

}
