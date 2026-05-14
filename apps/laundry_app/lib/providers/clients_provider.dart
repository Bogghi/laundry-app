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
    final futureUsers = SupabaseService.instance.users.getAll();
    return ClientsState(currUsers: futureUsers);
  }

  void fetchUsers() {
    state = state.copyWith(currUsers: SupabaseService.instance.users.getAll());
  }
}

final clientsProvider = NotifierProvider<ClientsProvider, ClientsState>(ClientsProvider.new);