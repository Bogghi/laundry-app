import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:shared_assets/utils/laundry_icons_map.dart';

import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/providers/items_provider.dart';
import 'package:laundry_app/presentations/screens/new_items_icon_picker/widgets/new_items_icon_picker_confirm_dialog.dart';

class NewItemsIconPickerPage extends ConsumerWidget {
  const NewItemsIconPickerPage({super.key});

  static final List<String> _iconKeys = (laundryIconsMap.keys.toList()..sort());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: LaundryTitle(text: "Seleziona icona")),
      body: LaundryScaffoldPadding(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.9,
          ),
          itemCount: _iconKeys.length,
          itemBuilder: (context, index) {
            final iconKey = _iconKeys[index];
            final totalRows = (_iconKeys.length / 3).ceil();
            final row = index ~/ 3;
            final col = index % 3;
            final borderRadius = _borderRadius(row, col, totalRows);

            return GestureDetector(
              onTap: () => _showConfirmDialog(context, ref, iconKey),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: HugeIcon(
                    icon: laundryIconsMap[iconKey]!,
                    size: 32,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    String iconKey,
  ) async {
    await showDialog(
      context: context,
      builder: (ctx) => NewItemsIconPickerConfirmDialog(
        iconKey: iconKey,
        onSave: (name) async {
          try {
            await ref.read(itemsProvider.notifier).createItem(name, iconKey);
          } catch (e) {
            debugPrint('createItem failed: $e');
            rethrow;
          }
          if (ctx.mounted) Navigator.of(ctx).pop();
          if (context.mounted) Navigator.of(context).pop(true);
        },
      ),
    );
  }

  BorderRadius _borderRadius(int row, int col, int totalRows) {
    const outside = Radius.circular(10.0);
    const inner = Radius.circular(4.0);
    final isTopEdge = row == 0;
    final isBottomEdge = row == totalRows - 1;
    final isLeftEdge = col == 0;
    final isRightEdge = col == 2;

    return BorderRadius.only(
      topLeft: (isTopEdge && isLeftEdge) ? outside : inner,
      topRight: (isTopEdge && isRightEdge) ? outside : inner,
      bottomLeft: (isBottomEdge && isLeftEdge) ? outside : inner,
      bottomRight: (isBottomEdge && isRightEdge) ? outside : inner,
    );
  }
}
