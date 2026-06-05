import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_assets/models/client_model.dart';

import 'package:laundry_app/providers/clients_provider.dart';
import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/screens/add_order/widgets/user_row.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/presentations/widgets/laundry_sub_heading.dart';
import 'package:laundry_app/utils/routes.dart';

class AssociateClient extends ConsumerStatefulWidget {
  final ValueChanged<ClientModel> onSelectedClient;
  final VoidCallback? onClearedClient;
  final FocusNode? focusNode;

  const AssociateClient({
    super.key,
    required this.onSelectedClient,
    this.onClearedClient,
    this.focusNode,
  });

  @override
  ConsumerState<AssociateClient> createState() => _AssociateClientState();
}

class _AssociateClientState extends ConsumerState<AssociateClient> {
  ClientModel? client;
  final TextEditingController _controller = TextEditingController();
  FocusNode? _ownedFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  @override
  void dispose() {
    _controller.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(clientsProvider);

    return FutureBuilder(
      future: userState.currUsers,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LaundryLoader();
        }

        final clients = snapshot.data!;
        return LaundryCard(
          child: Column(
            children: [
              Row(
                children: [
                  LaundrySubHeading(text: "Cliente"),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent
                    ),
                    onPressed: () async {
                      final result = await Navigator.of(context).pushNamed(Routes.registerClient);
                      if (result is ClientModel && context.mounted) {
                        setState(() {
                          client = result;
                          _controller.text = result.name;
                        });
                        widget.onSelectedClient(result);
                      }
                    },
                    child: Icon(Icons.add, size: 20),
                  )
                ],
              ),
              Autocomplete<ClientModel>(
                textEditingController: _controller,
                focusNode: _focusNode,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return clients
                    .where((client) => client.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                displayStringForOption: (client) => client.name,
                onSelected: (selectedClient) {
                  setState(() {
                    client = selectedClient;
                  });
                  widget.onSelectedClient(selectedClient);
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted
                ) {
                  return TextFormField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: AppTheme.primaryColorTone1),
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: "Cerca un cliente esistente",
                      hintStyle: TextStyle(
                        color: AppTheme.primaryColorTone1,
                        fontSize: 18,
                      ),
                    ),
                    style: TextStyle(
                      color: AppTheme.primaryColorTone1,
                      fontSize: 18,
                    ),
                  );
                },
              ),
              Visibility(
                visible: client != null,
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: UserRow(
                    name: client != null ? client!.name : '',
                    phoneNumber: client != null ? client!.phoneNumber.toString() : '',
                    onPressed: () {
                      setState(() {
                        client = null;
                        _controller.clear();
                      });
                      widget.onClearedClient?.call();
                    },
                  ),
                )
              ),
            ],
          )
        );
      }
    );
  }
}