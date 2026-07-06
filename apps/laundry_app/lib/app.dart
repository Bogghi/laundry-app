import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/screens/loading/loading_page.dart';
import 'package:laundry_app/providers/auth_provider.dart';
import 'package:laundry_app/utils/routes.dart';

class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Laundry App',
        theme: AppTheme.lightTheme,
        initialRoute: Routes.loadingPage,
        onGenerateInitialRoutes: (initialRoute) => [
          MaterialPageRoute(
            settings: RouteSettings(name: Routes.loadingPage),
            builder: (context) => LoadingPage(
              title: const Text('Pristine'),
              resolve: () async {
                await ref.read(authProvider.notifier).loadFromStorage();
                final auth = ref.read(authProvider);
                final navigator = App.navigatorKey.currentState;
                navigator?.pushReplacementNamed(
                  auth == null ? Routes.onboarding : Routes.home,
                );
              },
            ),
          ),
        ],
        navigatorKey: App.navigatorKey,
        routes: Routes.all,
    );
  }

  static final navigatorKey = GlobalKey<NavigatorState>();
}
