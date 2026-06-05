import 'package:flutter/material.dart';

import 'package:laundry_app/presentations/screens/home/home_page.dart';
import 'package:laundry_app/presentations/widgets/laundry_toast.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({super.key});

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args.containsKey('toastMessage')) {
        LaundryToast.show(context, args['toastMessage']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}