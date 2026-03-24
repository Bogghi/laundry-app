import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_app/utils/navigation_controller.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    )
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Laundry App',
      home: const NavigationController(),
    );
  }
}
