import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/washer_icon.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:laundry_app/presentations/screens/home/widgets/order_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';


class HomePage extends ConsumerWidget {
  final _future = Supabase.instance.client.from('orders').select();

  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                strokeCap: StrokeCap.round,
              )
            );
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
