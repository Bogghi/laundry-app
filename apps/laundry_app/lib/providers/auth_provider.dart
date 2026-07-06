import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_assets/models/user_model.dart';
import 'package:shared_assets/models/user_laundry_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

const _loggedInUserIdKey = 'logged_in_user_id';

class AuthState {
  final UserModel user;
  final UserLaundryModel? userLaundry;

  AuthState({required this.user, this.userLaundry});
}

class AuthNotifier extends Notifier<AuthState?> {
  @override
  AuthState? build() => null;

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_loggedInUserIdKey);
    if (userId == null) {
      state = null;
      return;
    }
    final user = await SupabaseService.instance.users.getById(userId);
    if (user == null) {
      state = null;
      return;
    }
    final userLaundry = await SupabaseService.instance.userLaundries.findForUser(user.id!);
    state = AuthState(user: user, userLaundry: userLaundry);
  }

  Future<void> login(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_loggedInUserIdKey, user.id!);
    final userLaundry = await SupabaseService.instance.userLaundries.findForUser(user.id!);
    state = AuthState(user: user, userLaundry: userLaundry);
  }

  Future<void> refreshUserLaundry() async {
    final current = state;
    if (current == null) return;
    final userLaundry = await SupabaseService.instance.userLaundries.findForUser(current.user.id!);
    state = AuthState(user: current.user, userLaundry: userLaundry);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInUserIdKey);
    state = null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState?>(AuthNotifier.new);
