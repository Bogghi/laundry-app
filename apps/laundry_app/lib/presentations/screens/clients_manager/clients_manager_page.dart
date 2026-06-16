import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:shared_assets/models/client_model.dart';

import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_toast.dart';
import 'package:laundry_app/providers/clients_provider.dart';
import 'package:laundry_app/utils/routes.dart';

class ClientsManagerPage extends ConsumerStatefulWidget {
  const ClientsManagerPage({super.key});

  @override
  ConsumerState<ClientsManagerPage> createState() => _ClientsManagerPageState();
}

class _ClientsManagerPageState extends ConsumerState<ClientsManagerPage> {
  // Ids dismissed via swipe. Filtered out immediately so the list shrinks on the
  // same frame the Dismissible animates away, before the async delete/refetch
  // catches up — otherwise Flutter throws "a dismissed Dismissible is still part
  // of the tree".
  final Set<int> _dismissedIds = {};

  Future<void> _openNewClient() async {
    final result = await Navigator.of(context).pushNamed(Routes.clientInfo);
    if (result is ClientModel && mounted) {
      ref.read(clientsProvider.notifier).fetchUsers();
      LaundryToast.show(context, "Cliente ${result.name} aggiunto");
    }
  }

  Future<void> _openEditClient(ClientModel client) async {
    final result = await Navigator.of(context).pushNamed(
      Routes.clientInfo,
      arguments: (client: client),
    );
    if (result is ClientModel && mounted) {
      ref.read(clientsProvider.notifier).fetchUsers();
      LaundryToast.show(context, "Cliente ${result.name} aggiornato");
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Gestione clienti"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewClient,
        child: HugeIcon(icon: HugeIcons.strokeRoundedAdd01),
      ),
      body: LaundryScaffoldPadding(
        child: FutureBuilder(
          future: clientsState.currUsers,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LaundryLoader();
            }

            final clients = snapshot.data!
                .where((c) => !_dismissedIds.contains(c.id))
                .toList();

            return RefreshIndicator(
              onRefresh: () async {
                ref.read(clientsProvider.notifier).fetchUsers();
                await ref.read(clientsProvider).currUsers;
              },
              child: clients.isEmpty ?
                ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text(
                          "Nessun cliente ancora registrato, aggiungi il tuo primo cliente",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(65, 71, 80, 100),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ) :
                ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Dismissible(
                            key: ValueKey(client.id),
                            direction: DismissDirection.endToStart,
                            background: const SizedBox.shrink(),
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedDelete02,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Eliminare cliente?"),
                                  content: Text(
                                    "Vuoi eliminare ${client.name}? "
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
                                        "Elimina",
                                        style: TextStyle(color: Colors.red.shade600),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              setState(() => _dismissedIds.add(client.id!));
                              ref.read(clientsProvider.notifier).deleteClient(client);
                              LaundryToast.show(context, "Cliente ${client.name} eliminato");
                            },
                            child: LaundryCard(
                              onTap: () => _openEditClient(client),
                              child: Row(
                                spacing: 10,
                                children: [
                                  HugeIcon(icon: HugeIcons.strokeRoundedUserCircle),
                                  Text(client.name),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                    );
                  }
                )
            );
          }
        ),
      ),
    );
  }
}