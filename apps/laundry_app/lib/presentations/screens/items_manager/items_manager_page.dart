import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/item_model.dart';

import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/presentations/widgets/laundry_grid.dart';
import 'package:laundry_app/presentations/widgets/laundry_toast.dart';
import 'package:laundry_app/providers/items_provider.dart';

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
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          final ctx = context;
                          try {
                            await ref
                                .read(itemsProvider.notifier)
                                .deleteItem(item.id);
                            if (mounted) {
                              LaundryToast.show(ctx, "Capo eliminato");
                            }
                          } catch (_) {
                            if (mounted) {
                              LaundryToast.show(ctx, "Errore eliminazione");
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openAddItemDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) => _AddItemDialog(
        onSave: (name) async {
          try {
            await ref.read(itemsProvider.notifier).createItem(name);
            if (ctx.mounted) Navigator.of(ctx).pop();
            if (mounted) LaundryToast.show(context, "Capo aggiunto");
          } catch (_) {
            if (mounted) LaundryToast.show(context, "Errore salvataggio");
          }
        },
      ),
    );
  }
}

class _AddItemDialog extends StatefulWidget {
  final Future<void> Function(String name) onSave;

  const _AddItemDialog({required this.onSave});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  late TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_controller.text.trim().isEmpty || _saving) return;

    setState(() => _saving = true);
    try {
      await widget.onSave(_controller.text);
    } catch (_) {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nuovo capo"),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: "Nome capo"),
        textCapitalization: TextCapitalization.sentences,
        enabled: !_saving,
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _handleSave(),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text("Annulla"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _saving || _controller.text.trim().isEmpty
              ? null
              : _handleSave,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  "Salva",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
        ),
      ],
    );
  }
}
