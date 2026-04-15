import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/screens/add_order/widgets/user_row.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';

class AssociateClient extends ConsumerStatefulWidget {
  const AssociateClient({super.key});

  @override
  ConsumerState<AssociateClient> createState() => _AssociateClientState();
}

class _AssociateClientState extends ConsumerState<AssociateClient> {
  final _future = Supabase.instance.client.from('clients').select();
  Map<String, dynamic>? client;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LaundryLoader();
        }

        final clients = snapshot.data!;
        return LaundryCard(
          child: Column(
            children: [
              Autocomplete<Map<String, dynamic>>(
                textEditingController: _controller,
                focusNode: _focusNode,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return clients
                    .where((client) => client['name'].toLowerCase().contains(textEditingValue.text.toLowerCase()))
                    .toList();
                },
                displayStringForOption: (Map<String, dynamic> client) => client['name'],
                onSelected: (Map<String, dynamic> selectedClient) {
                  print(selectedClient.toString());
                  setState(() {
                    client = selectedClient;
                  });
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
                    name: client != null ? client!['name'] : '',
                    phoneNumber: client != null ? client!['phone_number'].toString() : '',
                    onPressed: () {
                      setState(() {
                        client = null;
                        _controller.clear();
                      });
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