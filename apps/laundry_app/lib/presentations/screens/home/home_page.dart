import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/washer_icon.dart';

import 'package:laundry_app/presentations/screens/home/widgets/order_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

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
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return OrderCard();
        },
      )
    );
  }
}
