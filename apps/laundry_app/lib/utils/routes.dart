import 'package:flutter/material.dart';

import 'package:shared_assets/models/client_model.dart';
import 'package:shared_assets/models/order_model.dart';

import 'package:laundry_app/utils/navigation_controller.dart';
import 'package:laundry_app/presentations/screens/loading/loading_page.dart';
import 'package:laundry_app/presentations/screens/onboarding/onboarding_page.dart';
import 'package:laundry_app/presentations/screens/items_manager/items_manager_page.dart';
import 'package:laundry_app/presentations/screens/new_items_icon_picker/new_items_icon_picker_page.dart';
import 'package:laundry_app/presentations/screens/clients_manager/clients_manager_page.dart';
import 'package:laundry_app/presentations/screens/order_info/order_info_page.dart';

import 'package:laundry_app/presentations/screens/items_picker/items_picker_page.dart';
import 'package:laundry_app/presentations/screens/client_info/client_info_page.dart';

typedef LoadingPageArgs = ({Widget title, Future<void> Function() resolve});
typedef ClientInfoArgs = ({ClientModel? client});
typedef OrderInfoArgs = ({OrderModel? order});
typedef ItemsPickerArgs = ({String? source});

class Routes {
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String loadingPage = '/loading';
  static const String itemsManager = '/itemsManager';
  static const String newItemsIconPicker = '${Routes.itemsManager}/newItemsIconPicker';
  static const String clientsManagerPage = '/clientsManagerPage';
  static const String clientInfo = '/client_info';
  static const String orderInfo = '/order_info';
  static const String itemsPicker = '/items_picker';

  static final Map<String, WidgetBuilder> all = {
    home: (context) => const NavigationController(),
    onboarding: (context) => const OnboardingPage(),
    loadingPage: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as LoadingPageArgs;
      return LoadingPage(title: args.title, resolve: args.resolve);
    },
    itemsManager: (context) => const ItemsManagerPage(),
    newItemsIconPicker: (context) => const NewItemsIconPickerPage(),
    clientsManagerPage: (context) => const ClientsManagerPage(),
    clientInfo: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as ClientInfoArgs?;
      return ClientInfoPage(
        currClient: args?.client,
      );
    },
    orderInfo: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as OrderInfoArgs?;
      return OrderInfoPage(order: args?.order);
    },
    itemsPicker: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as ItemsPickerArgs?;
      return  ItemsPickerPage(source: args?.source);
    },
  };
}