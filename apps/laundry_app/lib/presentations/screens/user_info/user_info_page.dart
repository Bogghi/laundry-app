import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:shared_assets/models/laundry_model.dart';
import 'package:shared_assets/models/user_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

import 'package:laundry_app/app.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/providers/auth_provider.dart';
import 'package:laundry_app/utils/routes.dart';

class UserInfoPage extends ConsumerWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth?.user;
    final isOwner = user?.type == UserType.owner;
    final laundryId = auth?.userLaundry?.laundryId;

    return Scaffold(
      appBar: AppBar(title: LaundryTitle(text: "Il mio account")),
      body: LaundryScaffoldPadding(
        child: Column(
          spacing: 10,
          children: [
            LaundryCard(
              title: "Utente",
              child: Text(user?.username ?? "", style: TextStyle(fontSize: 18)),
            ),
            LaundryCard(
              title: "Ruolo",
              child: Text(isOwner ? "Proprietario" : "Dipendente", style: TextStyle(fontSize: 18)),
            ),
            if (isOwner && laundryId != null)
              FutureBuilder<LaundryModel?>(
                future: SupabaseService.instance.laundries.getById(laundryId),
                builder: (context, snapshot) {
                  final laundry = snapshot.data;
                  return LaundryCard(
                    title: "Attività",
                    child: Text(
                      laundry?.name ?? (snapshot.connectionState == ConnectionState.waiting ? "..." : "-"),
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  App.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    Routes.onboarding,
                    (route) => false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedLogout01, color: Colors.white),
                    Text("Esci", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
