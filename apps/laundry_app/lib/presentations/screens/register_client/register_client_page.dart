import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/client_model.dart';

import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/providers/clients_provider.dart';
import 'package:laundry_app/app_theme.dart';

class RegisterClientPage extends ConsumerStatefulWidget {
  const RegisterClientPage({super.key});

  @override
  ConsumerState<RegisterClientPage> createState() => _RegisterClientPageState();
}

class _RegisterClientPageState extends ConsumerState<RegisterClientPage> {
  late TextEditingController clientNameController;
  late TextEditingController phoneNumberController;
  bool _isSaving = false;

  @override
  void initState() {
    clientNameController = TextEditingController(text: ref.read(clientsProvider).clientName);
    phoneNumberController = TextEditingController(text: ref.read(clientsProvider).phoneNumber?.toString() ?? '');
    super.initState();
  }

  @override
  void dispose() {
    clientNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Nuovo Cliente"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _isSaving ? null : () async {
                setState(() => _isSaving = true);
                try {
                  final ClientModel savedClient = await ref.read(clientsProvider.notifier).saveClient();
                  if (mounted) {
                    Navigator.pop(context, savedClient);
                  }
                } finally {
                  if (mounted) setState(() => _isSaving = false);
                }
              },
              child: _isSaving
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
                : Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
          ),
        ],
      ),
      body: LaundryScaffoldPadding(
        child: Column(
          spacing: 10,
          children: [
            LaundryCard(
              title: "Nome Cliente",
              child: TextFormField(
                controller: clientNameController,
                onChanged: (value) {
                  ref.read(clientsProvider.notifier).setClientName(value);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: InputBorder.none,
                  hintText: "Mario Rossi",
                  hintStyle: TextStyle(
                    color: AppTheme.primaryColorTone1,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            LaundryCard(
              title: "Numero di telefono",
              child: TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ref.read(clientsProvider.notifier).setPhoneNumber(int.tryParse(value));
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: InputBorder.none,
                  hintText: "351 9283838",
                  hintStyle: TextStyle(
                    color: AppTheme.primaryColorTone1,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
