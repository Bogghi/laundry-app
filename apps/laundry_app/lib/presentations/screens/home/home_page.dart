import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/washer_icon.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Row(
            children: [
              WasherIcon(),
              SizedBox(width: 10),
              Text("Prestine")
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text("Home"),
      ),
    );
  }
}
