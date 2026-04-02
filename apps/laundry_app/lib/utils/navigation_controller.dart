import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_app/providers/app_provider.dart';
import 'package:laundry_app/presentations/screens/home/home_page.dart';
import 'package:laundry_app/presentations/screens/settings/settings_page.dart';
import 'package:laundry_app/presentations/screens/home/widgets/add_order_action.dart';

class NavigationController extends ConsumerStatefulWidget {
  const NavigationController({super.key});

  @override
  ConsumerState<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends ConsumerState<NavigationController> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final appStoreProvider = ref.read(appProvider.notifier);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        onDestinationSelected: (int index) {
          _pageController.jumpToPage(index);
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          appStoreProvider.changePage(index);
        },
        children: const [
          HomePage(),
          SettingsPage(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(appState.currentIndex),
    );
  }

  Widget? _buildFloatingActionButton(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return const AddOrderAction();
      default:
        return null;
    }
  }
}