import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_app/providers/app_provider.dart';

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
    final appState = ref.watch(appProvider);
    final appStoreProvider = ref.read(appProvider.notifier);

    return MaterialApp(
      title: 'Laundry App',
      home: Scaffold(
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              appStoreProvider.changePage(index);
            },
            selectedIndex: appState.currentIndex,
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(Icons.list_outlined),
                icon: Icon(Icons.list_outlined),
                label: 'Ordini',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.settings),
                icon: Icon(Icons.settings),
                label: 'Impostazioni',
              ),
            ],
          ),
          body: Center(
            child: Text("Home"),
          ),
      ),
    );
  }
}
