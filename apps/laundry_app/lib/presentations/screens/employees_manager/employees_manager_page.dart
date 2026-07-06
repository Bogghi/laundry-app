import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:shared_assets/models/user_laundry_model.dart';
import 'package:shared_assets/services/repositories/user_laundries_repository.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_toast.dart';
import 'package:laundry_app/providers/auth_provider.dart';
import 'package:laundry_app/providers/employees_provider.dart';

class EmployeesManagerPage extends ConsumerStatefulWidget {
  const EmployeesManagerPage({super.key});

  @override
  ConsumerState<EmployeesManagerPage> createState() => _EmployeesManagerPageState();
}

class _EmployeesManagerPageState extends ConsumerState<EmployeesManagerPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final laundryId = ref.read(authProvider)?.userLaundry?.laundryId;
      if (laundryId != null) {
        ref.read(employeesProvider.notifier).load(laundryId);
      }
    });
  }

  Future<void> _approve(EmployeeRequestModel request) async {
    await ref.read(employeesProvider.notifier).approve(request.userLaundry.id!);
    if (mounted) LaundryToast.show(context, "${request.user.username} approvato");
  }

  Future<void> _revoke(EmployeeRequestModel request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Revocare accesso?"),
        content: Text(
          "Vuoi revocare l'accesso di ${request.user.username}? "
          "Questa azione non può essere annullata.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Annulla"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Revoca",
              style: TextStyle(color: Colors.red.shade600),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(employeesProvider.notifier).revoke(request.userLaundry.id!);
    if (mounted) LaundryToast.show(context, "${request.user.username} rimosso");
  }

  @override
  Widget build(BuildContext context) {
    final employeesState = ref.watch(employeesProvider);
    final ownerUserId = ref.watch(authProvider)?.user.id;

    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Dipendenti"),
      ),
      body: LaundryScaffoldPadding(
        child: FutureBuilder(
          future: employeesState.employees,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LaundryLoader();
            }

            final requests = snapshot.data!;
            if (requests.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Text(
                        "Nessun dipendente ancora registrato",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(65, 71, 80, 100),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                final isPending = request.userLaundry.status == UserLaundryStatus.pending;
                final isOwnerRow = request.user.id == ownerUserId;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: LaundryCard(
                    child: Row(
                      children: [
                        HugeIcon(icon: HugeIcons.strokeRoundedUserCircle),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                request.user.username,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                isPending ? "In attesa di approvazione" : "Approvato",
                                style: TextStyle(
                                  color: isPending ? AppTheme.primaryColorTone1 : Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isPending)
                          IconButton(
                            onPressed: () => _approve(request),
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                              color: Colors.green.shade600,
                            ),
                          ),
                        if (!isOwnerRow)
                          IconButton(
                            onPressed: () => _revoke(request),
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedDelete02,
                              color: Colors.red.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
