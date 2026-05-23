import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_app/utils/routes.dart';
import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_sub_heading.dart';
import 'package:laundry_app/presentations/widgets/laundry_display_list.dart';
import 'package:laundry_app/presentations/screens/add_order/widgets/section_title.dart';
import 'package:laundry_app/presentations/screens/add_order/widgets/associate_client.dart';
import 'package:laundry_app/providers/items_provider.dart';
import 'package:laundry_app/providers/orders_provider.dart';

class AddOrderPage extends ConsumerStatefulWidget {
  const AddOrderPage({super.key});

  @override
  ConsumerState<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends ConsumerState<AddOrderPage> {
  late TextEditingController orderNumberController;
  final FocusNode _clientFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    orderNumberController = TextEditingController(text: ref.read(ordersProvider).orderNumber);
  }

  @override
  void dispose() {
    orderNumberController.dispose();
    _clientFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsProvider);
    final ordersState = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Nuovo ordine"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary
              ),
              onPressed: () async {
                try {
                  await ref.read(ordersProvider.notifier).saveOrder();
                  ref.read(ordersProvider.notifier).clearNewOrder();
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.home,
                      (route) => false,
                    );
                  }
                }
                catch(e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error saving order: $e')),
                    );
                  }
                }
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
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(text: "CAPI"),
              FutureBuilder(
                future: itemsState.currItems,
                builder: (context, snapshot) {
                  final selectedItems = ordersState.selectedItems;
                  final items = snapshot.data ?? [];
                  final selectedItemsList = items
                      .where((item) => selectedItems.containsKey(item.id))
                      .toList();

                  return LaundryCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        LaundrySubHeading(text: 'capi selezionati'),
                        LaundryDisplayList(
                          children: selectedItemsList.isEmpty
                            ? [const Text("Nessun capo selezionato")]
                            : [
                                ...selectedItemsList.map((item) => Row(
                                  children: [
                                    Text(item.name),
                                    const Spacer(),
                                    Text(
                                      "X${selectedItems[item.id]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              SectionTitle(text: "INFORMAZIONI"),
              LaundryCard(
                title: "numero ordine",
                child: TextFormField(
                  controller: orderNumberController,
                  onChanged: (value) {
                    ref.read(ordersProvider.notifier).setOrderNumber(value);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: InputBorder.none,
                    hintText: "#98",
                    hintStyle: TextStyle(
                      color: AppTheme.primaryColorTone1,
                      fontSize: 18,
                    ),
                  ),
                  style: TextStyle(
                    color: AppTheme.primaryColorTone1,
                    fontSize: 18,
                  ),
                ),
              ),
              AssociateClient(
                focusNode: _clientFocusNode,
                onSelectedClient: (client) {
                  ref.read(ordersProvider.notifier).setOrderClient(client);
                },
                onClearedClient: () {
                  ref.read(ordersProvider.notifier).setOrderClient(null);
                },
              ),
              LaundryCard(
                title: "data consegna",
                child: GestureDetector(
                  onTap: _selectDate,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        ordersState.deliveryDate != null
                            ? "${ordersState.deliveryDate!.day}/${ordersState.deliveryDate!.month}/${ordersState.deliveryDate!.year}"
                            : "Seleziona una data",
                        style: TextStyle(
                          color: ordersState.deliveryDate != null
                              ? AppTheme.primaryColorTone1
                              : AppTheme.primaryColorTone1.withValues(alpha: 0.4),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    _clientFocusNode.unfocus();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      ref.read(ordersProvider.notifier).setDeliveryDate(picked);
    }
  }
}
