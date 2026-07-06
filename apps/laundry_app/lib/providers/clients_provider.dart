import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/client_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

import 'package:laundry_app/providers/auth_provider.dart';

class ClientsState {
  final Future<List<ClientModel>>? currUsers;

  ClientsState({
    required this.currUsers,
  });

  ClientsState copyWith({
    Future<List<ClientModel>>? currUsers,
  }) {
    return ClientsState(
      currUsers: currUsers ?? this.currUsers,
    );
  }
}

class ClientsProvider extends Notifier<ClientsState> {
  int get _laundryId {
    final laundryId = ref.read(authProvider)?.userLaundry?.laundryId;
    if (laundryId == null) {
      throw StateError('Cannot access clients without a current laundry');
    }
    return laundryId;
  }

  @override
  ClientsState build() {
    final laundryId = ref.watch(authProvider)?.userLaundry?.laundryId;
    final futureUsers = laundryId == null
        ? Future.value(<ClientModel>[])
        : SupabaseService.instance.clients.getAll(laundryId);
    return ClientsState(currUsers: futureUsers);
  }

  void fetchUsers() {
    state = state.copyWith(currUsers: SupabaseService.instance.clients.getAll(_laundryId));
  }

  Future<ClientModel> saveClient({required String name, required int phoneNumber}) async {
    final ClientModel newClient = ClientModel(laundryId: _laundryId, name: name, phoneNumber: phoneNumber);
    return await SupabaseService.instance.clients.create(newClient);
  }

  Future<ClientModel> updateClient({
    required int id,
    required String name,
    required int phoneNumber,
  }) async {
    final ClientModel client = ClientModel(id: id, laundryId: _laundryId, name: name, phoneNumber: phoneNumber);
    return await SupabaseService.instance.clients.update(client);
  }

  Future<void> deleteClient(ClientModel client) async {
    final ClientModel deletedClient = ClientModel(
      id: client.id,
      laundryId: client.laundryId,
      name: client.name,
      phoneNumber: client.phoneNumber,
      status: ClientStatus.deleted,
    );
    await SupabaseService.instance.clients.update(deletedClient);
    fetchUsers();
  }
}

final clientsProvider = NotifierProvider<ClientsProvider, ClientsState>(ClientsProvider.new);
