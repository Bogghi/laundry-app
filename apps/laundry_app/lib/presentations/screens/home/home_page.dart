import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:shared_assets/icons/washer_icon.dart';

import 'package:laundry_app/providers/orders_provider.dart';
import 'package:laundry_app/presentations/screens/home/widgets/add_order_action.dart';
import 'package:laundry_app/presentations/screens/home/widgets/filter_panel.dart';
import 'package:laundry_app/presentations/screens/home/widgets/order_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/presentations/widgets/laundry_settings_row.dart';
import 'package:laundry_app/utils/routes.dart';
import 'package:laundry_app/app_theme.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  /// Shared open/closed flag for the filter panel. Lives here because the
  /// toggle trigger (AppBar icon) and the panel (body Stack) are in separate
  /// subtrees, so the flag must sit in their common ancestor. Held in [State]
  /// so its identity is stable across rebuilds/hot reloads — the [FilterPanel]
  /// registers a listener on it in initState, and that listener must keep
  /// pointing at the same notifier the AppBar icon toggles.
  final ValueNotifier<bool> _filterOpen = ValueNotifier(false);

  /// Live query for filtering the order list by client name. Owned here and
  /// shared with [FilterPanel], which binds its "Cliente" field to it. A
  /// TextEditingController is itself a ValueListenable, so the list rebuilds
  /// reactively as the user types.
  final TextEditingController _clientFilter = TextEditingController();

  /// Live query for filtering the order list by order number. Shared with
  /// [FilterPanel] the same way as [_clientFilter].
  final TextEditingController _orderNumberFilter = TextEditingController();

  @override
  void dispose() {
    _filterOpen.dispose();
    _clientFilter.dispose();
    _orderNumberFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            WasherIcon(width: 26, height: 26),
            SizedBox(width: 10),
            LaundryTitle(text: "Pristine"),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => _filterOpen.value = !_filterOpen.value,
            // Rebuild only the icon when either filter changes, to show/hide
            // the "filters active" dot without touching the rest of the AppBar.
            child: AnimatedBuilder(
              animation: Listenable.merge([_clientFilter, _orderNumberFilter]),
              builder: (context, _) {
                final hasFilter = _clientFilter.text.trim().isNotEmpty ||
                    _orderNumberFilter.text.trim().isNotEmpty;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedFilterMail),
                    if (hasFilter)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColorTone1,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).appBarTheme.backgroundColor ??
                                  Theme.of(context).scaffoldBackgroundColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: const LaundryTitle(text: "Pristine"),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackgroundColorShade1,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    LaundrySettingsRow(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(Routes.itemsManager);
                      },
                      hugeIcon: HugeIcons.strokeRoundedShirt01,
                      text: "Lista capi",
                    ),
                    LaundrySettingsRow(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(Routes.clientsManagerPage);
                      },
                      hugeIcon: HugeIcons.strokeRoundedUserGroup,
                      text: "Gestione clienti",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: orderState.currOrders,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LaundryLoader();
              }

              final orders = snapshot.data!;

              // Rebuild only the list as either query changes; the fetched
              // `orders` are captured above and not re-requested. Listenable.merge
              // fires the builder when either controller changes.
              return AnimatedBuilder(
                animation: Listenable.merge([_clientFilter, _orderNumberFilter]),
                builder: (context, _) {
                  final clientQuery = _clientFilter.text.trim().toLowerCase();
                  final numberQuery = _orderNumberFilter.text.trim().toLowerCase();
                  final hasFilter = clientQuery.isNotEmpty || numberQuery.isNotEmpty;

                  final filtered = !hasFilter
                      ? orders
                      : orders.where((o) {
                          final matchesClient = clientQuery.isEmpty ||
                              (o.client?.name ?? '')
                                  .toLowerCase()
                                  .contains(clientQuery);
                          final matchesNumber = numberQuery.isEmpty ||
                              o.orderNumber.toLowerCase().contains(numberQuery);
                          return matchesClient && matchesNumber;
                        }).toList();

                  // Empty source vs. empty result are different messages.
                  final emptyMessage = orders.isEmpty
                      ? "Aggiungi un ordine per tenerne traccia"
                      : "Nessun ordine trovato";

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.read(ordersProvider.notifier).fetchOrders();
                      await ref.read(ordersProvider).currOrders;
                    },
                    child: filtered.isEmpty ?
                      ListView(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Text(
                                emptyMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(65, 71, 80, 100),
                                  fontSize: 20,
                                )
                              ),
                            ),
                          ),
                        ],
                      ) :
                      ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: OrderCard(
                              order: filtered[index],
                              onTap: () {
                                ref.read(ordersProvider.notifier).loadOrder(filtered[index]);
                                Navigator.of(context).pushNamed(
                                  Routes.orderInfo,
                                  arguments: (order: filtered[index]),
                                );
                              },
                            ),
                          );
                        },
                      ),
                  );
                },
              );
            }
          ),
          // Scrim between the list and the panel: while the filter is open it
          // covers the whole body, swallowing taps so the list underneath can't
          // react, and a tap on it dismisses the panel (tap-outside-to-close).
          // Only this thin layer rebuilds on toggle — the list subtree above is
          // untouched.
          ValueListenableBuilder<bool>(
            valueListenable: _filterOpen,
            builder: (context, isOpen, _) {
              if (!isOpen) return const SizedBox.shrink();
              return Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // Surrender focus so the soft keyboard retracts — closing
                    // the panel only hides the fields, it doesn't drop focus.
                    FocusManager.instance.primaryFocus?.unfocus();
                    _filterOpen.value = false;
                  },
                ),
              );
            },
          ),
          FilterPanel(
            isOpen: _filterOpen,
            orderNumberController: _orderNumberFilter,
            clientController: _clientFilter,
          ),
        ]
      ),
      floatingActionButton: const AddOrderAction(),
    );
  }
}
