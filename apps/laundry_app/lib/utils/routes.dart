import 'package:flutter/material.dart';

import 'package:laundry_app/utils/navigation_controller.dart';
import 'package:laundry_app/presentations/screens/loading/loading_page.dart';

import 'package:laundry_app/presentations/screens/items_picker/items_picker_page.dart';
import 'package:laundry_app/presentations/screens/add_order/add_order_page.dart';
import 'package:laundry_app/presentations/screens/register_client/register_client_page.dart';

import 'package:laundry_app/presentations/screens/settings/settings_page.dart';
import 'package:laundry_app/presentations/screens/items_manager/items_manager_page.dart';

typedef LoadingPageArgs = ({Widget title, Future<void> Function() resolve});

class Routes {
  static const String home = '/';
  static const String loadingPage = '/loading';

  static const String itemsPicker = '/items_picker';
  static const String addOrder = '${Routes.itemsPicker}/add_order';
  static const String registerClient = '${Routes.itemsPicker}/register_client';

  static const String settings = '/settings';
  static const String itemsManager = '${Routes.settings}/itemsManager';

  static final Map<String, WidgetBuilder> all = {
    home: (context) => const NavigationController(),
    loadingPage: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as LoadingPageArgs;
      return LoadingPage(title: args.title, resolve: args.resolve);
    },

    itemsPicker: (context) => const ItemsPickerPage(),
    addOrder: (context) => const AddOrderPage(),
    registerClient: (context) => const RegisterClientPage(),

    settings: (context) => const SettingsPage(),
    itemsManager: (context) => const ItemsManagerPage(),
  };
}