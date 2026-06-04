import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/client_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

class ClientsState {
  final Future<List<ClientModel>>? currUsers;
  final String? clientName;
  final int? phoneNumber;

  ClientsState({
    required this.currUsers,
    this.clientName,
    this.phoneNumber,
  });

  ClientsState copyWith({
    Future<List<ClientModel>>? currUsers,
    String? clientName,
    int? phoneNumber,
  }) {
    return ClientsState(
      currUsers: currUsers ?? this.currUsers,
      clientName: clientName ?? this.clientName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
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