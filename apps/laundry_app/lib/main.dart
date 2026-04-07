import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:laundry_app/utils/navigation_controller.dart';
import 'package:laundry_app/presentations/screens/add_order/add_order_page.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Supabase.initialize(url: dotenv.env['PROJECT_URL']!, anonKey: dotenv.env['ANON_KEY']!);

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
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color.fromRGBO(0, 97, 164, 100),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const NavigationController(),
        '/add_order': (context) => const AddOrderPage(),
      }
    );
  }
}
