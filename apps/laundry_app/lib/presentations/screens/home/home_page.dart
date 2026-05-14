import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/icons/washer_icon.dart';

import 'package:laundry_app/providers/orders_provider.dart';
import 'package:laundry_app/presentations/screens/home/widgets/order_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';


class HomePage extends ConsumerWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(ordersProvider);
    final notifier = ref.read(ordersProvider.notifier);

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
      body: FutureBuilder(
        future: orderState.currOrders,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LaundryLoader();
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: OrderCard(),
              );
            },
          );
        }
      )
    );
  }
}
