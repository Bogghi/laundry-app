import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/utils/navigation_controller.dart';
import 'package:laundry_app/presentations/screens/add_order/add_order_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Laundry App',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const NavigationController(),
          '/add_order': (context) => const AddOrderPage(),
        }
    );
  }
}
