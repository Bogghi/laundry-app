import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/user_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

class UserState {
  final Future<List<UserModel>>? currUsers;

  UserState({
    required this.currUsers,
  });

  UserState copyWith({
    Future<List<UserModel>>? currUsers,
  }) {
    return UserState(
      currUsers: currUsers ?? this.currUsers,
    );
  }
}

class UserProvider extends Notifier<UserState> {
  @override
  UserState build() {
    final futureUsers = SupabaseService.instance.users.getAll();
    return UserState(currUsers: futureUsers);
  }

  void fetchUsers() {
    state = state.copyWith(currUsers: SupabaseService.instance.users.getAll());
  }
}

final userProvider = NotifierProvider<UserProvider, UserState>(UserProvider.new);