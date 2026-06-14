import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/client_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

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
  @override
  ClientsState build() {
    final futureUsers = SupabaseService.instance.clients.getAll();
    return ClientsState(currUsers: futureUsers);
  }

  void fetchUsers() {
    state = state.copyWith(currUsers: SupabaseService.instance.clients.getAll());
  }

  Future<ClientModel> saveClient({required String name, required int phoneNumber}) async {
    final ClientModel newClient = ClientModel(name: name, phoneNumber: phoneNumber);
    return await SupabaseService.instance.clients.create(newClient);
  }

  Future<ClientModel> updateClient({
    required int id,
    required String name,
    required int phoneNumber,
  }) async {
    final ClientModel client = ClientModel(id: id, name: name, phoneNumber: phoneNumber);
    return await SupabaseService.instance.clients.update(client);
  }
}

final clientsProvider = NotifierProvider<ClientsProvider, ClientsState>(ClientsProvider.new);
