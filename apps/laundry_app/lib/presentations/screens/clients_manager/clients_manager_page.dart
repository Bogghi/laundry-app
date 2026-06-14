import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_loader.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/providers/clients_provider.dart';
import 'package:laundry_app/utils/routes.dart';

class ClientsManagerPage extends ConsumerWidget {
  const ClientsManagerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsState = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Gestione clienti"),
      ),
      body: LaundryScaffoldPadding(
        child: FutureBuilder(
          future: clientsState.currUsers,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LaundryLoader();
            }

            final clients = snapshot.data!;

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
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: LaundryCard(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.clientInfo,
                            arguments: (client: clients[index]),
                          );
                        },
                        child: Row(
                          spacing: 10,
                          children: [
                            HugeIcon(icon: HugeIcons.strokeRoundedUserCircle),
                            Text(clients[index].name),
                          ],
                        ),
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