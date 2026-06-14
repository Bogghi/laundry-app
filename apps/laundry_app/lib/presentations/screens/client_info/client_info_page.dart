import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/client_model.dart';

import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/providers/clients_provider.dart';
import 'package:laundry_app/app_theme.dart';

class ClientInfoPage extends ConsumerStatefulWidget {
  final ClientModel? currClient;

  const ClientInfoPage({
    super.key,
    this.currClient,
  });

  @override
  ConsumerState<ClientInfoPage> createState() => _ClientInfoPageState();
}

class _ClientInfoPageState extends ConsumerState<ClientInfoPage> {
  late TextEditingController clientNameController;
  late TextEditingController phoneNumberController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    clientNameController = TextEditingController(text: widget.currClient?.name ?? '');
    phoneNumberController = TextEditingController(text: widget.currClient?.phoneNumber.toString() ?? '');
  }

  @override
  void dispose() {
    clientNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: widget.currClient != null ? "Modifica Cliente" : "Nuovo Cliente"),
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
                  final String name = clientNameController.text;
                  final int phoneNumber = int.parse(phoneNumberController.text);
                  final notifier = ref.read(clientsProvider.notifier);

                  final ClientModel savedClient;
                  if (widget.currClient == null) {
                    savedClient = await notifier.saveClient(
                      name: name,
                      phoneNumber: phoneNumber,
                    );
                  } else {
                    savedClient = await notifier.updateClient(
                      id: widget.currClient!.id!,
                      name: name,
                      phoneNumber: phoneNumber,
                    );
                  }

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
