import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/washer_icon.dart';

import 'package:laundry_app/presentations/screens/home/widgets/order_card.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends ConsumerWidget {
  final _future = Supabase.instance.client.from('orders').select();

  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 249, 250, 100),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 249, 250, 100),
        title: Row(
          children: [
            WasherIcon(width: 26, height: 26),
            SizedBox(width: 10),
            Text(
              "Pristine",
              style: TextStyle(
                color: Color.fromARGB(255, 30, 58, 138),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderCard();
            },
          );
        }
      )
    );
  }
}
