import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/user_laundry_model.dart';
import 'package:shared_assets/services/repositories/user_laundries_repository.dart';
import 'package:shared_assets/services/supabase_service.dart';

class EmployeesState {
  final Future<List<EmployeeRequestModel>> employees;

  EmployeesState({required this.employees});

  EmployeesState copyWith({Future<List<EmployeeRequestModel>>? employees}) {
    return EmployeesState(employees: employees ?? this.employees);
  }
}

class EmployeesNotifier extends Notifier<EmployeesState> {
  int? _laundryId;

  @override
  EmployeesState build() {
    return EmployeesState(employees: Future.value(const []));
  }

  void load(int laundryId) {
    _laundryId = laundryId;
    state = state.copyWith(employees: SupabaseService.instance.userLaundries.findForLaundry(laundryId));
  }

  void _refetch() {
    if (_laundryId != null) load(_laundryId!);
  }

  Future<void> approve(int userLaundryId) async {
    await SupabaseService.instance.userLaundries.updateStatus(
      id: userLaundryId,
      status: UserLaundryStatus.approved,
    );
    _refetch();
  }

  Future<void> revoke(int userLaundryId) async {
    await SupabaseService.instance.userLaundries.delete(userLaundryId);
    _refetch();
  }
}

final employeesProvider = NotifierProvider<EmployeesNotifier, EmployeesState>(EmployeesNotifier.new);
