import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/item_model.dart';

import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_sub_heading.dart';
import 'package:laundry_app/presentations/widgets/laundry_display_list.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/providers/items_provider.dart';
import 'package:laundry_app/utils/routes.dart';

class ItemsPickerPage extends ConsumerStatefulWidget {
  const ItemsPickerPage({super.key});

  @override
  ConsumerState<ItemsPickerPage> createState() => _ItemsPickerPageState();
}

class _ItemsPickerPageState extends ConsumerState<ItemsPickerPage> {
  final List<Map<String, dynamic>> clothingItems = [
    {'name': 'Camicia', 'icon': Icons.checkroom},
    {'name': 'Pantalone', 'icon': Icons.assignment},
    {'name': 'Giacca', 'icon': Icons.assignment_ind},
    {'name': 'Maglietta', 'icon': Icons.checkroom},
    {'name': 'Calzini', 'icon': Icons.assessment},
    {'name': 'Mutande', 'icon': Icons.assignment_late},
  ];

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsProvider);

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
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: itemsState.currItems,
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return LaundryLoader();
              }

              final List<ItemModel>? items = snapshot.data;
              return Column(
                children: [
                  LaundryCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.0,
                      children: [
                        LaundrySubHeading(text: "capi selezionati"),
                        LaundryDisplayList(children: [
                          Row(
                            children: [
                              Text("Camicia"),
                              Spacer(),
                              Text(
                                "X2",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text("Pantalone"),
                              Spacer(),
                              Text(
                                "X3",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text("Giacca"),
                              Spacer(),
                              Text(
                                "X4",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ])
                      ],
                    )
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(items!.length, (index) {
                      return _buildClothingGridItem(index, items[index]);
                    }),
                  ),
                ],
              );
            }
          ),
        ),
      )
    );
  }

  Widget _buildClothingGridItem(int index, ItemModel item) {
    final row = index ~/ 2;
    final col = index % 2;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: _gridElementBorderRadius(row, col, 3, 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checkroom, size: 40, color: Colors.grey[800]),
          const SizedBox(height: 8),
          Text(
            item.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Aggiungi"),
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
