import 'package:flutter/material.dart';

import 'package:laundry_app/presentations/screens/add_order/add_order_page.dart';
import 'package:laundry_app/presentations/screens/items_picker/items_picker_page.dart';
import 'package:laundry_app/presentations/screens/register_client/register_client_page.dart';
import 'package:laundry_app/utils/navigation_controller.dart';

class Routes {
  static const String home = '/';
  static const String addOrder = '/add_order';
  static const String registerClient = '/register_client';
  static const String itemsPicker = '/items_picker';

  static final Map<String, WidgetBuilder> all = {
    home: (context) => const NavigationController(),
    addOrder: (context) => const AddOrderPage(),
    registerClient: (context) => const RegisterClientPage(),
    itemsPicker: (context) => const ItemsPickerPage(),
  };
}
