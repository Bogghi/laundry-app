
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppState {
  final int currentIndex;

  AppState({
    required this.currentIndex,
  });

  AppState copyWith({int? currentIndex}) => AppState(
    currentIndex: currentIndex ?? this.currentIndex
  );
}

class AppProvider extends Notifier<AppState> {
  @override
  AppState build() {
    return AppState(currentIndex: 0);
  }

  void changePage(int? index) {
    state = state.copyWith(currentIndex: index);
  }
}

final appProvider = NotifierProvider<AppProvider, AppState>(AppProvider.new);