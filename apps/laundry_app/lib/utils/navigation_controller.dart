import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/user_model.dart';
import 'package:shared_assets/models/user_laundry_model.dart';

import 'package:laundry_app/presentations/screens/home/home_page.dart';
import 'package:laundry_app/presentations/screens/home/widgets/laundry_access_request_dialog.dart';
import 'package:laundry_app/presentations/widgets/laundry_toast.dart';
import 'package:laundry_app/providers/auth_provider.dart';

class NavigationController extends ConsumerStatefulWidget {
  const NavigationController({super.key});

  @override
  ConsumerState<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends ConsumerState<NavigationController> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args.containsKey('toastMessage')) {
        LaundryToast.show(context, args['toastMessage']);
      }

      final auth = ref.read(authProvider);
      if (auth == null || auth.user.type != UserType.employ) return;

      final status = auth.userLaundry?.status;
      if (status == UserLaundryStatus.approved) return;

      if (status == UserLaundryStatus.pending) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Richiesta in attesa'),
            content: const Text('La tua richiesta di accesso è in attesa di approvazione da parte del proprietario.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LaundryAccessRequestDialog(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}