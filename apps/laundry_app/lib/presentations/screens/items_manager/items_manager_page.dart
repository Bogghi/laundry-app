import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:shared_assets/models/item_model.dart';
import 'package:shared_assets/utils/huge_icons_map.dart';

import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/presentations/widgets/laundry_grid.dart';
import 'package:laundry_app/presentations/widgets/laundry_toast.dart';
import 'package:laundry_app/providers/items_provider.dart';
import 'package:laundry_app/utils/routes.dart';

class ItemsManagerPage extends ConsumerStatefulWidget {
  const ItemsManagerPage({super.key});

  @override
  ConsumerState<ItemsManagerPage> createState() => _ItemsManagerPageState();
}

class _ItemsManagerPageState extends ConsumerState<ItemsManagerPage> {
  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(title: LaundryTitle(text: "Lista Capi")),
      body: LaundryScaffoldPadding(
        child: FutureBuilder(
          future: itemsState.currItems,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LaundryLoader();
            }

            final List<ItemModel> items = snapshot.data!;

            if (items.isEmpty) {
              return const Center(
                child: Text("Nessun capo. Aggiungi il primo!"),
              );
            }

            return LaundryGrid(
              itemCount: items.length,
              childAspectRatio: 0.75,
              itemBuilder: (index, borderRadius) {
                final item = items[index];

                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        HugeIcon(
                          icon: hugeIconsMap[item.iconName]!,
                          size: 40,
                          color: Colors.grey[800],
                        ),
                        Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            final ctx = context;
                            try {
                              await ref
                                .read(itemsProvider.notifier)
                                .deleteItem(item);
                              if (mounted) {
                                LaundryToast.show(ctx, "Capo eliminato");
                              }
                            } catch (e) {
                              if (mounted) {
                                LaundryToast.show(ctx, "Errore eliminazione");
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                              ),
                              Text(
                                style: TextStyle(
                                  color: Colors.white
                                ),
                                "Elimina",
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.pushNamed(context, Routes.newItemsIconPicker);
          if (saved == true && mounted) {
            LaundryToast.show(context, "Capo aggiunto");
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
