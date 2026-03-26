import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/washer_icon.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
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
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Tile n $index"),
          );
        },
      )
    );
  }
}
