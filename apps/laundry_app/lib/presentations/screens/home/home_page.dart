import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:shared_assets/icons/washer_icon.dart';

import 'package:laundry_app/providers/orders_provider.dart';
import 'package:laundry_app/presentations/screens/home/widgets/add_order_action.dart';
import 'package:laundry_app/presentations/screens/home/widgets/order_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/presentations/widgets/laundry_settings_row.dart';
import 'package:laundry_app/utils/routes.dart';
import 'package:laundry_app/app_theme.dart';


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            WasherIcon(width: 26, height: 26),
            SizedBox(width: 10),
            LaundryTitle(text: "Pristine"),
          ],
        )
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
                    borderRadius: BorderRadius.circular(20)
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
      body: FutureBuilder(
        future: orderState.currOrders,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LaundryLoader();
          }

          final orders = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(ordersProvider.notifier).fetchOrders();
              await ref.read(ordersProvider).currOrders;
            },
            child: orders.isEmpty ?
              ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Text(
                        "Aggiungi un ordine per tenerne traccia",
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
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: OrderCard(
                      order: orders[index],
                      onTap: () {
                        ref.read(ordersProvider.notifier).loadOrder(orders[index]);
                        Navigator.of(context).pushNamed(
                          Routes.orderInfo,
                          arguments: (order: orders[index]),
                        );
                      },
                    ),
                  );
                },
              ),
          );
        }
      ),
      floatingActionButton: const AddOrderAction(),
    );
  }
}
