import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/screens/loading/loading_page.dart';
import 'package:laundry_app/presentations/widgets/laundry_toast.dart';
import 'package:laundry_app/providers/auth_provider.dart';
import 'package:laundry_app/utils/routes.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();

  static final navigatorKey = GlobalKey<NavigatorState>();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _revalidateSession();
  }

  Future<void> _revalidateSession() async {
    if (ref.read(authProvider) == null) return;
    final revoked = await ref.read(authProvider.notifier).revalidate();
    if (!revoked) return;

    final navigator = App.navigatorKey.currentState;
    final context = navigator?.context;
    navigator?.pushNamedAndRemoveUntil(Routes.onboarding, (route) => false);
    if (context != null && context.mounted) {
      LaundryToast.show(context, 'Sessione scaduta: autorizzazione revocata');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
                await ref.read(authProvider.notifier).revalidate();
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
}
