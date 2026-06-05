import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/client_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

const _sentinel = Object();

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
    Object? phoneNumber = _sentinel,
  }) {
    return ClientsState(
      currUsers: currUsers ?? this.currUsers,
      clientName: clientName ?? this.clientName,
      phoneNumber: phoneNumber == _sentinel ? this.phoneNumber : phoneNumber as int?,
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

  void setClientName(String clientName) {
    state = state.copyWith(clientName: clientName);
  }

  void setPhoneNumber(int? phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  Future<ClientModel> saveClient() async {
    try {
      final ClientModel newClient = ClientModel(
        name: state.clientName!,
        phoneNumber: state.phoneNumber!,
      );
      final ClientModel savedClient = await SupabaseService.instance.clients.create(newClient);
      return savedClient;
    }
    catch (e) {
      rethrow;
    }
  }
}

final clientsProvider = NotifierProvider<ClientsProvider, ClientsState>(ClientsProvider.new);
